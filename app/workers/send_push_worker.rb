class SendPushWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(opts)
    OneSignalClient.create_notification(opts)
  end
end