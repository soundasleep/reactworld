class AddEntranceToLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :levels, :entrance_x, :integer, null: false, default: -1
    add_column :levels, :entrance_y, :integer, null: false, default: -1
  end
end
