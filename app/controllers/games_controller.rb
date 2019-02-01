class GamesController < ApplicationController
  before_action :require_user

  def new
    game = current_user.games.create!
    level = GenerateLevel.new(game: game, depth: 1).call
    game.update_attributes! current_level: level

    flash[:notices] = "Created new game #{game}. You enter a dark and spooky cavern."

    redirect_to game
  end

  def show
    @game = current_user.games.find(params[:id])

    unless @game.current_level.present?
      if @game.levels.empty?
        GenerateLevel.new(game: @game, depth: 1).call
      end

      flash[:notices] = "You got lost - putting you back to the start."
      @game.update_attributes! current_level: @game.levels.order(depth: :asc).first
    end

    redirect_to [@game, @game.current_level]
  end

  def destroy
    @game = current_user.games.find(params[:id])
    @game.destroy!

    flash[:notices] = "Deleted #{@game}. That world is no longer with us"

    redirect_to root_path
  end
end
