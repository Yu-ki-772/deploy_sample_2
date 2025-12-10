class AddRecommendationToDiagnoses < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnoses, :recommendation, :jsonb
  end
end
