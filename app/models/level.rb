class Level < ApplicationRecord
  belongs_to :game

  validates :depth, numericality: { greater_than: 0 }

  def to_s
    "<Level #{id} at depth #{depth}>"
  end

  def assign_tiles(array_of_arrays)
    flattened = array_of_arrays.map do |row|
      row.join(",")
    end.join(";")

    assign_attributes(tiles: flattened)
  end

  def tiles_as_arrays
    @tiles_as_arrays ||= tiles.split(";").map do |row|
      row.split(",")
    end
  end
end
