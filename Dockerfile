# Dockerfile (production, multi-stage)
ARG RUBY_VERSION=3.3.6
FROM ruby:${RUBY_VERSION}-slim AS base

ENV LANG C.UTF-8
ENV TZ=Asia/Tokyo
ENV RAILS_ENV=production
ENV BUNDLE_DEPLOYMENT=1
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_WITHOUT=development:test

WORKDIR /app

# 基本パッケージ（runtime）
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
     curl ca-certificates libjemalloc2 libvips libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# ---- build stage ----
FROM base AS build

ENV DEBIAN_FRONTEND=noninteractive

# build に必要なパッケージ
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
     build-essential git pkg-config python3 make gcc \
  && rm -rf /var/lib/apt/lists/*

# node (production)：apt で node を入れる（Node 20）
ARG NODE_MAJOR=20
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x bullseye main" \
     > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

# Copy Gemfiles and install gems (cache-friendly)
COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document \
  && bundle install --jobs 4 --retry 3

# Copy package files and install JS deps
COPY package.json yarn.lock ./
RUN npm install -g yarn@1.22.22 || true
RUN yarn install --frozen-lockfile --production=false

# Copy app source
COPY . .

# Precompile bootsnap / assets
RUN bundle exec bootsnap precompile --gemfile || true
RUN SECRET_KEY_BASE=dummy bin/rails assets:precompile

# remove dev node_modules to keep final image slim if you want
RUN rm -rf node_modules

# ---- final stage ----
FROM base

# copy gems and app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# create app user
RUN groupadd --system --gid 1000 rails \
  && useradd --system --uid 1000 --gid rails --create-home --shell /bin/bash rails \
  && mkdir -p /app/tmp /app/log \
  && chown -R rails:rails /app

USER rails

WORKDIR /app

EXPOSE 3000

# Entrypoint: container 起動時に DB マイグレーション等は上位で実行する想定
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
