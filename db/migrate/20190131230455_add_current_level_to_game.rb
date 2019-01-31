class AddCurrentLevelToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :current_level_id, :integer, null: true # null if the level hasn't been created yet
  end
end
