# Handle logic around resolving disagreements (peacefully).

module KombatLogic
  extend ActiveSupport::Concern

  SEED_NUMBER_MAX = 9
  IDENTICAL = 'same'.freeze

  def calculate_fight_outcome(params)
    h1 = params[:hero_1]
    h2 = params[:hero_2]
    return IDENTICAL if h1 == h2 # Small easter egg



  end
end

# Tech design:
# The user will provide a SEED number between 1-9
# Retrieve the bio for each character and parse the “description” field
# Choose the WORD in each description at the position corresponding to the provided SEED
# The winner of the battle is the character whose WORD has the most characters EXCEPT if either character's WORD is a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
# Present the winning character to the user
# Handle any errors or edge cases and display the message in a user friendly manner
