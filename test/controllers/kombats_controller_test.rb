require 'test_helper'

class KombatsControllerTest < ActiveSupport::TestCase
  setup { stub_marvel_service }

  test 'identical' do
    params = { hero_1: 123, hero_2: 123 }
    assert_equal KombatLogic::IDENTICAL, KombatsController.new.calculate_fight_outcome(params)[:outcome]
  end

  test 'tie' do
    params = {
      hero_1: 123, hero_1_seed: 1,
      hero_2: 987, hero_2_seed: 1
    }
    # This is 'reverse' vs 'finally'
    assert_equal KombatLogic::TIE, KombatsController.new.calculate_fight_outcome(params)[:outcome]
  end

  test 'magic words (gamma)' do
    params = {
      hero_1: 123, hero_1_seed: 1,
      hero_2: 987, hero_2_seed: 5
    }
    # This is 'reverse' vs 'gamma'
    assert_equal 2, KombatsController.new.calculate_fight_outcome(params)[:outcome]
  end

  test 'regular conflict - h1 wins' do
    params = {
      hero_1: 123, hero_1_seed: 1,
      hero_2: 987, hero_2_seed: 2
    }
    # This is 'reverse' vs 'a'
    assert_equal 1, KombatsController.new.calculate_fight_outcome(params)[:outcome]
  end

  test 'regular conflict - h2 wins' do
    params = {
      hero_1: 123, hero_1_seed: 4,
      hero_2: 987, hero_2_seed: 1
    }
    # This is 'to' vs 'finally'
    assert_equal 2, KombatsController.new.calculate_fight_outcome(params)[:outcome]
  end
end
