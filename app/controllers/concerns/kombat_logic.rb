# Handle logic around resolving disagreements (peacefully).

module KombatLogic
  extend ActiveSupport::Concern

  INSTANT_WINS = ['gamma', 'radioactive'].freeze
  INSTANT_WIN_VALUE = 9001.freeze # It's over 9000!
  SPLIT_REGEX = %r{\s+}.freeze
  DESCRIPTION_CLEANUP_REGEX = %r{[[:punct:]]}.freeze
  TIE = 0.freeze
  ERROR = -1.freeze
  IDENTICAL = -2.freeze
  SEED_NUMBER_MAX = 9.freeze

  def calculate_fight_outcome(params)
    return { outcome: IDENTICAL } if params[:hero_1] == params[:hero_2] # No parallel universe fights please
    marvel = MarvelService.new
    hero1 = marvel.hero_data_for params[:hero_1]
    hero2 = marvel.hero_data_for params[:hero_2]

    h1_value = calculate_fight_value hero1, params[:hero_1_seed].to_i
    h2_value = calculate_fight_value hero2, params[:hero_2_seed].to_i

    outcome_code = if h1_value == h2_value
               TIE
             elsif h1_value > h2_value
               1
             else
               2
             end
    {
      outcome: outcome_code,
      hero_1: hero1,
      hero_2: hero2
    }
  end

  def calculate_fight_value(hero, seed)
    result = hero[:description].split(SPLIT_REGEX)
      .map { |s| s.gsub(DESCRIPTION_CLEANUP_REGEX, '') }
      .map(&:downcase)[seed - 1] # Adjust seed to array notation

    return INSTANT_WIN_VALUE if INSTANT_WINS.include? result # It's over 9000!
    result.length
  end
end

# Tech design:
# The user will provide a SEED number between 1-9
# Retrieve the bio for each character and parse the “description” field
# Choose the WORD in each description at the position corresponding to the provided SEED
# The winner of the battle is the character whose WORD has the most characters EXCEPT if either character's WORD is a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
# Present the winning character to the user
# Handle any errors or edge cases and display the message in a user friendly manner
