class Workout < ApplicationRecord
  BODY_PARTS = %W[全身 腕 胸 腹 脚].freeze
  PURPOSES = %w[筋力アップ 筋肥大 筋持久力向上].freeze

  validates :body_part, inclusion: { in: BODY_PARTS }
  validates :purpose, inclusion: { in: PURPOSES}

  def self.recommend(is_beginner:, body_part:, purpose:)
    exersises = find_exercises(is_beginner, body_part)
    intensity = calculate_intensity(purpose)

    {
     exersises: exersises,
     pace: intensity[:pace],
     reps: intensity[:reps],
     sets: intensity[:sets],
     rest: intensity[:rest],
     tips: generate_tips(is_beginner, purpose)
    }
  end

  private

  def self.find_exercises(is_beginner, body_part)
    case body_part
    when '全身'
      is_beginner ? 'バーピー(腕立て無し)' : 'バーピー'
    when '腕'
      is_beginner ? '上腕二頭筋：手幅狭めの懸垂、上腕三頭筋：リバースプッシュアップ' : '上腕二頭筋：手幅狭めの懸垂、上腕三頭筋：ディップス'
    when '胸'
      is_beginner ? 'プッシュアップ（手幅広め）' : 'ディップス'
    when '腹'
      is_beginner ? '腹直筋：クランチ, 腹斜筋：バイシクルクランチ' : 'ドラゴンフラッグ'
    when '脚'
      is_beginner ? '大腿四頭筋：スクワット、ハムストリングス：ハムストリングスライド' : '大腿四頭筋：ブルガリアンスクワット、ハムストリングス：ハムストリングスライド（片足上げた状態で）'
    end
  end


  def self.calculate_intensity(purpose)
    case purpose
    when '筋力アップ'
      { pace: '指定なし', reps: '8～12回', sets: '3セット', rest: '2～5分' }
    when '筋肥大'
      { pace: '遅め（特にネガティブ方向を遅めに）', reps: '8～12回', sets: '3セット', rest: '30～90秒' }
    when '筋持久力向上'
      { pace: 'やや速め', reps: '特に目安なし', sets: '5セット前後', rest: '30秒以下' }
    end
  end

  def self.generate_tips(is_beginner, purpose)
    tips = []
    tips << '正しいフォームを意識しましょう' if is_beginner
    tips << '呼吸を止めないように意識しましょう'
    tips << 'オーバーワークに注意しましょう'
    tips << 'ポジティブ方向の動作の瞬発性を意識しましょう' if purpose == '筋力アップ'
    tips
  end
end
