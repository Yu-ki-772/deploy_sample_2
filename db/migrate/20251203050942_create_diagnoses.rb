class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :is_beginner, null: false
      t.string :body_part, null: false
      t.string :purpose, null: false
      t.jsonb :result

      t.timestamps
    end
  end
end
