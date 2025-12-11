class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :player_id, null: false
      t.string :device_type

      t.timestamps
    end
    add_index :devices, :player_id, unique: true
  end
end
