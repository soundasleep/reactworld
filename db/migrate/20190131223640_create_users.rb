class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :refresh_token
      t.string :access_token
      t.timestamp :expires

      t.timestamps
    end
  end
end
