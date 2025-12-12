class DevicesController < ApplicationController
  skip_forgery_protection only: [:create, :destroy]

  def create
    player_id = params.require(:player_id)
    
    # 既存デバイスを探すか、新規作成
    device = Device.find_or_initialize_by(player_id: player_id)
    device.device_type = params[:device_type] || 'web'
    
    # ログインしている場合、user_idを紐付ける
    # 既に別のユーザーに紐付いている場合は上書きしない
    if current_user && device.user_id.nil?
      device.user_id = current_user.id
    end
    
    device.save!
    render json: { success: true, device: device }, status: :ok
    
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    player_id = params[:player_id] || params[:id]
    device = Device.find_by(player_id: player_id)
    device&.destroy
    head :no_content
  end
end
