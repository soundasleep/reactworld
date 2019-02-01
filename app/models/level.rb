class Level < ApplicationRecord
  belongs_to :game

  has_many :monsters, dependent: :destroy

  validates :depth, numericality: { greater_than: 0 }
  validates :width, :height, :entrance_x, :entrance_y,
      numericality: { greater_than_or_equal: 0 }

  validate :entrance_is_within_bounds

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

  def within_bounds?(x, y)
    x >= 0 && y >= 0 && x < width && y < height
  end

  def tile_is_visitable?(x, y)
    within_bounds?(x, y) && Tile::is_visitable?(tiles_as_arrays[y][x]) && !any_monster_at?(x, y)
  end

  def any_monster_at?(x, y)
    monsters.where(monster_x: x, monster_y: y).any?
  end

  private

  def entrance_is_within_bounds
    if entrance_x.present? && width.present? && entrance_y.present? && height.present?
      errors.add(:entrance_x, "is outside of bounds") unless within_bounds?(entrance_x, entrance_y)
      errors.add(:entrance_y, "is outside of bounds") unless within_bounds?(entrance_x, entrance_y)
    end
  end
end
