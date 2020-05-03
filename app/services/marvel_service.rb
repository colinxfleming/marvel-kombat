# Logic around calling the Marvel API.

# Service object handles all data requesting.
class MarvelService
  class APIError < StandardError; end

  BASE_URL = "https://gateway.marvel.com/v1/public".freeze
  CHAR_INDEX = "#{BASE_URL}/characters".freeze
  MAX_RESULTS = 100.freeze

  def hero_selection
    request(CHAR_INDEX).map { |x| map_character(x) }
  end

  def hero_data_for(hero_id)
    request("#{CHAR_INDEX}/#{hero_id}").map { |x| map_character(x) }[0]
  end

  private

  def map_character(char)
    {
      id: char['id'],
      description: char['description'],
      name: char['name'],
    }
  end

  def request(url)
    url = "#{url}"
    resp = Faraday.get(url) do |req|
      req.params = req_authorization_params
    end
    raise_for_status resp
    content = JSON.parse resp.body
    heroes = content['data']['results']

    # Marvel doesn't paginate so we fake it with some ugly loops
    total = content['data']['total']
    Rails.logger.debug "#{total} heroes to pull"
    offset = heroes.count
    until total == heroes.count
      Rails.logger.debug "Pulled #{offset} so far"
      resp = Faraday.get(url) do |req|
        req.params = req_authorization_params(offset)
      end
      raise_for_status resp
      heroes = heroes.concat JSON.parse(resp.body)['data']['results']
      offset = heroes.count
    end
    heroes
  end

  def raise_for_status(resp)
    if resp.status != 200
      raise APIError.new(JSON.parse(resp.body)['status'])
    end
  end

  def req_authorization_params(offset = 0)
    ts = Time.zone.now.to_i
    pubkey = Rails.application.credentials.dig :marvel_pubkey
    privatekey = Rails.application.credentials.dig :marvel_privatekey

    {
      ts: Time.zone.now.to_i,
      apikey: pubkey,
      hash: Digest::MD5.hexdigest("#{ts}#{privatekey}#{pubkey}"),
      limit: MAX_RESULTS,
      orderBy: 'name',
      offset: offset
    }
  end
end

# to worry about
# 429 requests exceeded
# 24 hour caching recommended
