ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def stub_marvel_service
    index_result = {
      'data': {
        'total': 8,
        'results': [
          {'id': 123, 'description': 'Reverse Batman fights to make the streets less clean', 'name': 'Reverse Batman'},
          {'id': 456, 'description': 'Paper Shredder is not really notable', 'name': 'Paper Shredder'}, # Should get filtered
          {'id': 789, 'description': '', 'name': 'Double Reverse Batman'}, # Should get filtered
          {'id': 987, 'description': 'Finally, a hero with GAMMA GLASSES to inspire the world with perfect vision', 'name': 'Biclops'}
        ]
      }
    }
    stub_request(:get, MarvelService::CHAR_INDEX)
      .with(query: hash_including({}))
      .to_return(body: index_result.to_json)

    reverse_batman = {
      'data': {
        'total': 1,
        'results': [
          {'id': 123, 'description': 'Reverse Batman fights to make the streets less clean', 'name': 'Reverse Batman'},
        ]
      }      
    }
    stub_request(:get, "#{MarvelService::CHAR_INDEX}/123")
      .with(query: hash_including({}))
      .to_return(body: reverse_batman.to_json)

    biclops = {
      'data': {
        'total': 1,
        'results': [
          {'id': 987, 'description': 'Finally, a hero with GAMMA GLASSES to inspire the world with perfect vision', 'name': 'Biclops'}
        ]
      }      
    }
    stub_request(:get, "#{MarvelService::CHAR_INDEX}/987")
      .with(query: hash_including({}))
      .to_return(body: biclops.to_json)
  end
end
