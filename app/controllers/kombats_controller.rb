class KombatsController < ApplicationController
  include KombatLogic

  def index
    # Some heroes (like, for ex, 3-D Man) don't have descriptions,
    # or may have descriptions under the seed #. Filter those out.
    # Poor 3-D Man :(
    @hero_selection = MarvelService.new.hero_selection
      .reject { |x| x[:description].blank? || x[:description].split(SPLIT_REGEX).count < SEED_NUMBER_MAX }
      .map { |x| [x[:name], x[:id]] }
  end

  def fight
    # Outcome is in the KombatLogic concern.
    # Display logic is in kombats_helper.
    @result = calculate_fight_outcome params
    puts @result
    respond_to { |format| format.js }
  end
end
