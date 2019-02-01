class LevelsController < ApplicationController
  before_action :require_user
  before_action :require_game
  before_action :find_level

  def show
    unless @level.present?
      return redirect_to current_game
    end
  end

  def regenerate
    @level.destroy!
    new_level = GenerateLevel.new(game: @level.game, depth: @level.depth).call

    flash[:notices] = "#{@level} has been burninated. Regenerated level #{new_level}."

    redirect_to [current_game, new_level]
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
end
