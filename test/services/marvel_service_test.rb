require 'test_helper'

class MarvelServiceTest < ActiveSupport::TestCase
  setup { stub_marvel_service }

  test 'retrieves all heroes' do
    output = MarvelService.new.hero_selection
    # Should iterate thru twice because of the total of 8
    # The real api doesn't have dupes, but that's okay for our purposes here
    assert_equal 8, output.count
    assert_equal 2, output.select { |x| x[:id] == 123 }.count # Proxy for pulling things down right
  end

  test 'retrieves single hero' do
    output = MarvelService.new.hero_data_for 123

    assert_equal 'Reverse Batman', output[:name]
  end
end
