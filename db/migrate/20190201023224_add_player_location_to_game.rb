class AddPlayerLocationToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player_x, :integer, null: true # null if they haven't entered a level yet
    add_column :games, :player_y, :integer, null: true # null if they haven't entered a level yet
  end
end
