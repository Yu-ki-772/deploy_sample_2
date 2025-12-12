class SendDiagnosisNotificationJob < ApplicationJob
  queue_as :pushes

  def perform(diagnosis_id)
    # 1. Diagnosisを取得
    diagnosis = Diagnosis.find(diagnosis_id)
    
    # 2. 診断結果を受け取るユーザーを取得
    user = diagnosis.user
    
    # 3. そのユーザーの全デバイスのplayer_idを取得
    player_ids = user.devices.pluck(:player_id)
    
    # デバイスが登録されていない場合は何もしない
    return if player_ids.empty?
    
    # 4. 通知のペイロードを作成
    payload = {
      app_id: ONESIGNAL_APP_ID,
      include_player_ids: player_ids,
      headings: { 
        en: "診断結果",
        ja: "診断結果"
      },
      contents: { 
        en: "診断結果が出ました。",
        ja: "診断結果が出ました。"
      },
      url: "#{ENV['APP_URL']}/diagnoses/#{diagnosis.id}",
      data: { 
        diagnosis_id: diagnosis.id,
        type: 'diagnosis_result'
      }
    }
    
    # 5. OneSignal APIを呼び出して通知を送信
    OnesignalClient.create_notification(payload)
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Diagnosis not found: #{e.message}"
  rescue OnesignalClient::Error => e
    Rails.logger.error "OneSignal error: #{e.message}"
  end
end
