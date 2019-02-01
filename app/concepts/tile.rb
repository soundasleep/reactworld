class Tile
  EMPTY = 0
  WALL = 1
  FLOOR = 2

  def self.is_visitable?(tile)
    tile.to_i == Tile::FLOOR.to_i
  end
end
