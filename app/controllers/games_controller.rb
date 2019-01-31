class GamesController < ApplicationController
  before_action :require_user

  def new
    game = current_user.games.create!

    flash[:notices] = "Created new game #{game}."

    redirect_to game
  end

  def show
    @game = current_user.games.find(params[:id])
  end
end
