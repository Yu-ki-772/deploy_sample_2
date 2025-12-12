class Diagnosis < ApplicationRecord
  belongs_to :user

  validates :is_beginner, inclusion: { in: [true, false] }
  validates :body_part, :purpose, presence: true

  after_update :enqueue_notification_if_result_added

  private
  
  def enqueue_notification_if_result_added
    # resultがnilから値に変わったときだけ実行したい
    if saved_change_to_result? && result_before_last_save.nil?
      SendDiagnosisNotificationJob.perform_later(self.id)
    end
  end
end
