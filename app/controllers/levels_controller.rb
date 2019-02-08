class LevelsController < ApplicationController
  before_action :require_user
  before_action :require_game
  before_action :find_level

  def show
    unless @level.present?
      return redirect_to current_game
    end

    if @level == current_game.current_level
      if current_game.player_x.nil? || current_game.player_y.nil?
        current_game.update_attributes! player_x: @level.entrance_x, player_y: @level.entrance_y
      end
    end

    respond_to do |format|
      format.html
      format.json {
        render json: local_level_as_json(@level, current_game)
      }
    end
  end

  def regenerate
    # Reset the players' location
    if @level == current_game.current_level
      current_game.update_attributes! player_x: nil, player_y: nil, current_level: nil
    end

    @level.destroy!
    new_level = GenerateLevel.new(game: @level.game, depth: @level.depth).call

    flash[:notices] = "#{@level} has been burninated. Regenerated level #{new_level}."

    redirect_to current_game
  end

  def north
    return apply_movement! x: 0, y: -1, message: "You have travelled north"
  end

  def south
    return apply_movement! x: 0, y: 1, message: "You have travelled south"
  end

  def west
    return apply_movement! x: -1, y: 0, message: "You have travelled west"
  end

  def east
    return apply_movement! x: 1, y: 0, message: "You have travelled east"
  end

  private

  helper_method :current_game

  def current_game
    @current_game ||= current_user.games.find_by(id: params[:game_id])
  end

  def require_game
    unless current_game.present?
      flash[:errors] = "No such game found!"

      redirect_to root_path
    end
  end

  def find_level
    @level = current_game.levels.find_by(params[:level_id] || params[:id])
  end

  def apply_movement!(x:, y:, message: "You have travelled")
    raise ArgumentError, "Can't move on a level you're not on" unless @level == current_game.current_level

    tiles = @level.tiles_as_arrays
    new_x = current_game.player_x + x
    new_y = current_game.player_y + y

    any_errors = any_notices = nil

    if @level.within_bounds?(new_x, new_y)
      if @level.tile_is_visitable?(new_x, new_y)
        current_game.update_attributes!({
          player_x: new_x,
          player_y: new_y,
        })

        any_notices = message
      else
        any_errors = "You feel a mysterious force pushing you back."
      end
    else
      any_errors = "You would fall off the edge of the universe!"
    end

    move_monsters!

    return respond_to do |format|
      format.html do
        flash[:notices] = any_notices
        flash[:errors] = any_errors
        redirect_to [current_game, @level]
      end

      format.json do
        render json: {
          messages: any_notices,
          errors:   any_errors,
          level:    local_level_as_json(@level, current_game),
        }
      end
    end
  end

  def move_monsters!
    @level.monsters.each do |monster|
      next if monster.dead?

      # move 50% of the time
      if rand(2) <= 1
        # Move randomly
        movement = [:north, :south, :west, :east].sample
        dx = 0
        dy = 0

        case movement
        when :north
          dy = -1
        when :south
          dy = 1
        when :west
          dx = -1
        when :east
          dx = 1
        else
          raise ArgumentError, "Did not expect monster movement of #{movement}"
        end

        if @level.tile_is_visitable?(monster.monster_x + dx, monster.monster_y + dy)
          unless @level.any_monster_at?(monster.monster_x + dx, monster.monster_y + dy)
            unless current_game.player_x == monster.monster_x + dx && current_game.player_y == monster.monster_y + dy
              monster.update_attributes! monster_x: monster.monster_x + dx, monster_y: monster.monster_y + dy
            end
          end
        end
      end
    end
  end

  helper_method :local_level_as_json
  def local_level_as_json(level, game)
    player_x = game.player_x
    player_y = game.player_y

    visibility = 3

    tiles = []
    (-visibility .. visibility).each do |dy|
      row = []

      (-visibility .. visibility).each do |dx|
        if level.within_bounds?(player_x + dx, player_y + dy)
          tile = {
            x: player_x + dx,
            y: player_y + dy,
            tile: level.tiles_as_arrays[player_y + dy][player_x + dx],
            monsters: monsters_as_json(level.monsters_at(player_x + dx, player_y + dy)),
          }

          if dx == 1 && dy == 0
            tile[:visit_path] = game_level_east_path(game, level, format: :json)
          elsif dx == -1 && dy == 0
            tile[:visit_path] = game_level_west_path(game, level, format: :json)
          elsif dx == 0 && dy == 1
            tile[:visit_path] = game_level_south_path(game, level, format: :json)
          elsif dx == 0 && dy == -1
            tile[:visit_path] = game_level_north_path(game, level, format: :json)
          end

          row << tile
        end
      end

      tiles << row unless row.empty?
    end

    return {
      player: {
        x: player_x,
        y: player_y,
      },
      tiles: tiles,
    }
  end

  def monsters_as_json(monsters)
    monsters.map do |monster|
      monster_as_json(monster)
    end
  end

  def monster_as_json(monster)
    {
      type: monster.monster_type,
      x: monster.monster_x,
      y: monster.monster_y,
      alive: monster.alive?,
      health: monster.health,
      level: monster.monster_level,
    }
  end
end
