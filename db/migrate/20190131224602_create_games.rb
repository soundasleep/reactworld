class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :user_id, null: false
      t.datetime :finished_at, null: true

      t.timestamps
    end
  end
end
