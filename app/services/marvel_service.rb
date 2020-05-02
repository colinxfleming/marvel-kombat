# Logic around calling the Marvel API.

# Service object handles all data requesting.
class MarvelService
  BASE_URL = "https://gateway.marvel.com/v1/public"
  CHAR_INDEX = "#{BASE_URL}/characters"

  def hero_selection
    request(CHAR_INDEX).map { |x| _map_character(x) }
  end

  def hero_data_for(hero)

  end

  def _map_character(char)
    {
      id: char['id'],
      description: char['description'],
      name: char['name'],
    }
  end

  private

  def request(url)
    url = "#{url}"
    resp = Faraday.get(url) do |req|
      req.params = req_authorization_params
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
