class DevicesController < ApplicationController
  # 認証があれば入れてください（例: before_action :authenticate_user!）

  skip_forgery_protection only: [:create] # API で CSRF を別に処理するなら調整

  def create
    player_id = params.require(:player_id)
    device = Device.find_or_initialize_by(player_id: player_id)
    device.device_type = params[:device_type] || 'web'
    device.save!
    render json: { success: true }, status: :ok
  end

  def destroy
    player_id = params[:player_id] || params[:id]
    device = Device.find_by(player_id: player_id)
    device&.destroy
    head :no_content
  end
end
