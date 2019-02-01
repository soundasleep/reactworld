class CreateMonsters < ActiveRecord::Migration[5.2]
  def change
    create_table :monsters do |t|
      t.integer :level_id,      null: false
      t.integer :monster_x,     null: false
      t.integer :monster_y,     null: false
      t.integer :health,        null: false
      t.integer :monster_level, null: false
      t.string :monster_type,   null: false, limit: 32

      t.timestamps
    end
  end
end
