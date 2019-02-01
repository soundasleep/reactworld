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
    apply_movement! x: 0, y: -1, message: "You have travelled north"
    redirect_to [current_game, @level]
  end

  def south
    apply_movement! x: 0, y: 1, message: "You have travelled south"
    redirect_to [current_game, @level]
  end

  def west
    apply_movement! x: -1, y: 0, message: "You have travelled west"
    redirect_to [current_game, @level]
  end

  def east
    apply_movement! x: 1, y: 0, message: "You have travelled east"
    redirect_to [current_game, @level]
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

    if @level.within_bounds?(new_x, new_y)
      if Tile::is_visitable?(tiles[new_y][new_x])
        current_game.update_attributes!({
          player_x: new_x,
          player_y: new_y,
        })

        flash[:notices] = message
      else
        flash[:errors] = "You feel a mysterious force pushing you back."
      end
    else
      flash[:errors] = "You would fall off the edge of the universe!"
    end
  end
end
