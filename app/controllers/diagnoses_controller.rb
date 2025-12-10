class DiagnosesController < ApplicationController
  skip_before_action :require_login, only: %i[new]
  def new
    @diagnosis = Diagnosis.new
  end

  def create
    @diagnosis = Diagnosis.new(diagnosis_params)
    @diagnosis.user = current_user

    recommendation = Workout.recommend(
      is_beginner: @diagnosis.is_beginner,
      body_part: @diagnosis.body_part,
      purpose: @diagnosis.purpose
    )

    @diagnosis.result = recommendation

    if @diagnosis.save
      redirect_to diagnosis_path(@diagnosis)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @diagnosis = Diagnosis.find(params[:id])
    @recommendation = @diagnosis.result
  end

  def index
    @diagnoses = current_user&.diagnoses&.order(created_at: :desc) || []
  end

  private

  def diagnosis_params
    params.require(:diagnosis).permit(:is_beginner, :body_part, :purpose)
  end
end
