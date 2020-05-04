# Handle logic around resolving disagreements (peacefully).

# Tech design:
# The user will provide a SEED number between 1-9
# Retrieve the bio for each character and parse the “description” field
# Choose the WORD in each description at the position corresponding to the provided SEED
# The winner of the battle is the character whose WORD has the most characters EXCEPT if either character's WORD is a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
# Present the winning character to the user
# Handle any errors or edge cases and display the message in a user friendly manner

module KombatLogic
  extend ActiveSupport::Concern

  INSTANT_WINS = ['gamma', 'radioactive'].freeze
  SPLIT_REGEX = %r{\s+}.freeze
  DESCRIPTION_CLEANUP_REGEX = %r{[[:punct:]]}.freeze
  TIE = 0.freeze
  ERROR = -1.freeze
  IDENTICAL = -2.freeze
  SEED_NUMBER_MAX = 9.freeze

  def calculate_fight_outcome(params)
    return { outcome: IDENTICAL } if params[:hero_1] == params[:hero_2] # No parallel universe fights please

    begin
      marvel = MarvelService.new
      hero1 = marvel.hero_data_for params[:hero_1]
      hero2 = marvel.hero_data_for params[:hero_2]
    rescue MarvelService::APIError => e
      return { outcome: ERROR, reason: e.message }
    end

    h1_value = calculate_fight_value hero1, params[:hero_1_seed].to_i
    h2_value = calculate_fight_value hero2, params[:hero_2_seed].to_i

    outcome_code = calculate_winner h1_value, h2_value
    {
      outcome: outcome_code,
      hero_1: hero1,
      hero_2: hero2
    }
  end

  def calculate_winner(h1_value, h2_value)
    # Note that we are assuming here that radioactive doesn't beat gamma
    # because it's longer
    h1_instant_win = INSTANT_WINS.include? h1_value
    h2_instant_win = INSTANT_WINS.include? h2_value

    # Ugmo
    if h1_instant_win && h2_instant_win
      TIE
    elsif h1_instant_win
      1
    elsif h2_instant_win
      2
    elsif h1_value.length == h2_value.length
      TIE
    elsif h1_value.length > h2_value.length
      1
    else
      2
    end
  end

  def calculate_fight_value(hero, seed)
    result = hero[:description].split(SPLIT_REGEX)
      .map { |s| s.gsub(DESCRIPTION_CLEANUP_REGEX, '') }
      .map(&:downcase)[seed - 1] # Adjust seed to array notation

    result
  end
end
