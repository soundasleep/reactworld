class GenerateLevel
  attr_reader :game, :depth

  def initialize(game: game, depth: depth)
    @game = game
    @depth = depth
  end

  def call
    generate_level
  end

  private

  def generate_level
    width = 40
    height = 20

    level = game.levels.new(width: width, height: height, depth: depth)

    tiles = (0..height).map do |y|
      (0..width).map do |y|
        Tile::EMPTY
      end
    end

    100.times do
      y = rand(height)
      x = rand(width)
      tiles[y][x] = Tile::WALL
    end

    # Map back down
    level.assign_tiles(tiles)

    level.save!

    return level
  end
end
