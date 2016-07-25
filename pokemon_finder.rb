require "net/http"
require "uri"
require "pry"
require 'json'

uri = URI.parse("https://pokevision.com/map/data/34.00762867221067/-118.49833130836488")
rand = Random.new

# https://docs.google.com/spreadsheets/d/1PiBGv76OpeaW95r-5x3xbK5suWFDSXE5Zweq9j7kKhs/htmlview?sle=true#
pokemon_ids = {
  #129 => :magikarp,
  131 => :lapras,
  #147 => :dratini
  148 => :dragonair,
  149 => :dragonite,
  130 => :exeggutor,
  143 => :snorlax,
  134 => :vaporeon,
  142 => :snorlax,
  113 => :chansey,
  40 => :wigglytuff
}

loop do
  begin
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)['pokemon'].each do |pokemon|
      if pokemon_ids.keys.include? pokemon['pokemonId'].to_i
        expires_at = Time.at(pokemon['expiration_time'])
        pokemon_id = pokemon['pokemonId']
        pokemon_name = pokemon_ids[pokemon_id.to_i]
        latitude = pokemon['latitude']
        longitude = pokemon['longitude']

        open('pokemon_found.txt', 'a') do |f|
          f << [pokemon_name, expires_at, latitude, longitude]
        end
      end
    end

    sleep(rand.rand(60) + 60) # vary ping interval

  rescue => e
    puts e.inspect
    next
  end
end