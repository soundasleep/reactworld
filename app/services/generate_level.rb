class GenerateLevel
  attr_reader :game, :depth, :width, :height

  def initialize(game: game, depth: depth, width: 60, height: 20)
    @game = game
    @depth = depth
    @width = width
    @height = height
  end

  def call
    generate_level
  end

  private

  def empty_tiles(width, height)
    (0...height).map do |y|
      (0...width).map do |y|
        Tile::EMPTY
      end
    end
  end

  def generate_level
    width = 40
    height = 30

    level = game.levels.new(width: width, height: height, depth: depth)

    tiles = empty_tiles(width, height)

    rooms = 5.times.map do |i|
      x = rand(width - 2) + 1
      y = rand(height - 2) + 1
      radius_x = rand(4) + 1
      radius_y = rand(4) + 1

      if i.zero?
        level.assign_attributes entrance_x: x, entrance_y: y
      end

      { x: x, y: y, radius_x: radius_x, radius_y: radius_y }
    end

    # Draw rooms
    rooms.each do |room|
      fill_rect! tiles,
        Tile::FLOOR,
        from_x: [0,           room[:x] - room[:radius_x]].max,
        from_y: [0,           room[:y] - room[:radius_y]].max,
        to_x:   [width - 1,   room[:x] + room[:radius_x]].min,
        to_y:   [height - 1,  room[:y] + room[:radius_y]].min,
        overwrite: true

      draw_rect! tiles,
        Tile::WALL,
        from_x: [0,           room[:x] - room[:radius_x] - 1].max,
        from_y: [0,           room[:y] - room[:radius_y] - 1].max,
        to_x:   [width - 1,   room[:x] + room[:radius_x] + 1].min,
        to_y:   [height - 1,  room[:y] + room[:radius_y] + 1].min,
        overwrite: false
    end

    # Draw corridors
    previous_room = rooms.first

    rooms.each do |next_room|
      next if next_room == previous_room

      # horizontal (along y)
      fill_rect! tiles,
        Tile::FLOOR,
        from_x: [0,           previous_room[:x]].max,
        from_y: [0,           previous_room[:y]].max,
        to_x:   [width - 1,   next_room[:x]].min,
        to_y:   [height - 1,  previous_room[:y]].min,
        overwrite: true

      draw_rect! tiles,
        Tile::WALL,
        from_x: [0,           previous_room[:x] - 1].max,
        from_y: [0,           previous_room[:y] - 1].max,
        to_x:   [width - 1,   next_room[:x] + 1].min,
        to_y:   [height - 1,  previous_room[:y] + 1].min,
        overwrite: false

      # vertical (along x)
      fill_rect! tiles,
        Tile::FLOOR,
        from_x: [0,           next_room[:x]].max,
        from_y: [0,           previous_room[:y]].max,
        to_x:   [width - 1,   next_room[:x]].min,
        to_y:   [height - 1,  next_room[:y]].min,
        overwrite: true

      draw_rect! tiles,
        Tile::WALL,
        from_x: [0,           next_room[:x] - 1].max,
        from_y: [0,           previous_room[:y] - 1].max,
        to_x:   [width - 1,   next_room[:x] + 1].min,
        to_y:   [height - 1,  next_room[:y] + 1].min,
        overwrite: false

      previous_room = next_room
    end

    level.assign_tiles(tiles)

    level.save!

    generate_monsters! level, up_to: ((width + height) / 2).floor

    return level
  end

  def fill_rect!(tiles, tile, from_x:, to_x:, from_y:, to_y:, overwrite: true)
    if from_y > to_y
      return fill_rect! tiles, tile, from_y: to_y, to_y: from_y, from_x: from_x, to_x: to_x, overwrite: overwrite
    end
    if from_x > to_x
      return fill_rect! tiles, tile, from_x: to_x, to_x: from_x, from_y: from_y, to_y: to_y, overwrite: overwrite
    end

    if from_y < 0 || from_y > tiles.length
      raise ArgumentError, "from_y of #{from_y} is out of bounds #{tiles.length}"
    end
    if to_y < 0 || to_y > tiles.length
      raise ArgumentError, "to_y of #{to_y} is out of bounds #{tiles.length}"
    end

    if from_x < 0 || from_x > tiles.first.length
      raise ArgumentError, "from_x of #{from_x} is out of bounds #{tiles.first.length}"
    end
    if to_x < 0 || to_x > tiles.first.length
      raise ArgumentError, "to_x of #{to_x} is out of bounds #{tiles.first.length}"
    end

    ( from_y .. to_y ).each do |y|
      ( from_x .. to_x ).each do |x|
        if overwrite || tiles[y][x] == Tile::EMPTY
          tiles[y][x] = tile
        end
      end
    end
  end

  def draw_rect!(tiles, tile, from_x:, to_x:, from_y:, to_y:, overwrite: true)
    # Lazy mode: just fill rectangles of width 1

    # North
    fill_rect! tiles, tile, from_x: from_x, to_x: to_x, from_y: from_y, to_y: from_y, overwrite: overwrite

    # South
    fill_rect! tiles, tile, from_x: from_x, to_x: to_x, from_y: to_y, to_y: to_y, overwrite: overwrite

    # West
    fill_rect! tiles, tile, from_x: from_x, to_x: from_x, from_y: from_y, to_y: to_y, overwrite: overwrite

    # North
    fill_rect! tiles, tile, from_x: to_x, to_x: to_x, from_y: from_y, to_y: to_y, overwrite: overwrite
  end

  def generate_monsters!(level, up_to:)
    up_to.times do
      x = rand(level.width)
      y = rand(level.height)

      if level.tile_is_visitable?(x, y) && !level.any_monster_at?(x, y)
        monster = level.monsters.create!({
          monster_x: x,
          monster_y: y,
          health: 5 + rand(10),
          monster_level: 1,
          monster_type: Monster::SPIDER,
        })
      end
    end
  end
end
