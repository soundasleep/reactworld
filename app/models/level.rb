class Level < ApplicationRecord
  belongs_to :game

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

  private

  def entrance_is_within_bounds
    if entrance_x.present? && width.present?
      if entrance_x < 0 || entrance_x >= width
        errors.add(:entrance_x, "is outside of width bounds #{width}")
      end
    end
    if entrance_y.present? && height.present?
      if entrance_y < 0 || entrance_y >= height
        errors.add(:entrance_y, "is outside of height bounds #{height}")
      end
    end
  end
end
