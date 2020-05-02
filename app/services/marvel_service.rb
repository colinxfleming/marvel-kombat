# Logic around calling the Marvel API.

# Service object handles all data requesting.
class MarvelService
  class APIError < StandardError; end

  BASE_URL = "https://gateway.marvel.com/v1/public"
  CHAR_INDEX = "#{BASE_URL}/characters"

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

    if resp.status != 200
      raise APIError.new(JSON.parse(resp.body)['status'])
    end
    JSON.parse(resp.body)['data']['results']
  end

  def req_authorization_params
    ts = Time.zone.now.to_i
    pubkey = Rails.application.credentials.dig(:marvel_pubkey)
    privatekey = Rails.application.credentials.dig(:marvel_privatekey)

    {
      ts: Time.zone.now.to_i,
      apikey: pubkey,
      hash: Digest::MD5.hexdigest("#{ts}#{privatekey}#{pubkey}")
    }
  end
end

# to worry about
# 429 requests exceeded
# 24 hour caching recommended
