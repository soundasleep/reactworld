class CreateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :levels do |t|
      t.integer :game_id, null: false
      t.integer :depth,   null: false, default: 0
      t.integer :width,   null: false
      t.integer :height,  null: false
      t.text :tiles,      null: false

      t.timestamps
    end
  end
end
