class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new
  end

  def create
    @user = login(params[:email], params[:password], params[:remember_me])
    if @user
      redirect_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました', status: :see_other
  end
end
