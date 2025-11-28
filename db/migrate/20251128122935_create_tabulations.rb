class CreateTabulations < ActiveRecord::Migration[7.2]
  def change
    create_table :tabulations do |t|
      t.string :category
      t.string :result

      t.timestamps
    end
  end
end
