class KombatsController < ApplicationController
  def index
    @content = ::MarvelService.new
  end

  def fight
    hero_1 = params[:hero_1]
    hero_2 = params[:hero_2]
    @result = "#{hero_2} beats #{hero_1}"
    respond_to { |format| format.js }
  end

  private

  def fight_params
    # todo
  end
end
