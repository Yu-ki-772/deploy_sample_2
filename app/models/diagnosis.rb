class Diagnosis < ApplicationRecord
  belongs_to :user

  validates :is_beginner, inclusion: { in: [true, false] }
  validates :body_part, :purpose, presence: true
end
