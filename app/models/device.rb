class Device < ApplicationRecord
  belongs_to :user, optional: true
  validates :player_id, presence: true, uniqueness: true
end
