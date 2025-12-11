class PushController < ApplicationController
  skip_forgery_protection only: [:test]

  def test
    player_id = params.require(:player_id)
    payload = {
      app_id: ONESIGNAL_APP_ID,
      include_player_ids: [player_id],
      headings: { en: "Test Alert" },
      contents: { en: "This is a test push from Rails." },
      data: { test: true }
    }
    result = OneSignalClient.create_notification(payload)
    render json: result
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
