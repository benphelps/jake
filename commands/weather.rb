# frozen_string_literal: true

ForecastIO.api_key = ENV['DARKSKY_KEY']

def degrees(num)
  num.round.to_s + ' °'
end

def percent(num)
  (num * 100.0).round.to_s + '%'
end

BOT.command :weather, aliases: [:we, :w], description: 'Display current weather information for your profiles location.' do |event, *lookup|
  if lookup
    geocoded = Geocoder.search(lookup.join(' '))&.first
  else
    user = User.find_or_create(discord_id: event.author.id)
    location = user.settings_dataset.first(key: 'location')&.value
    geocoded = Geocoder.search(lookup)&.first
  end

  if geocoded
    lat, long = geocoded.coordinates
    forecast = ForecastIO.forecast(lat, long)&.currently

    if forecast
      event.channel.send_embed do |embed|
        embed.title = geocoded.data['display_name']
        embed.description = forecast.summary
        embed.add_field(name: "Temp", value: degrees(forecast.temperature), inline: true)
        embed.add_field(name: "Feels Like", value: degrees(forecast.apparentTemperature), inline: true)
        embed.add_field(name: "Humidity", value: percent(forecast.humidity), inline: true)
        embed.add_field(name: "Chance of Rain", value: percent(forecast.precipProbability), inline: true)
      end
    end
  end
end

# <Geocoder::Result::Nominatim:0x00007f9d75008f10
#   @data={
#     "place_id"=>200399981,
#     "licence"=>"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
#     "boundingbox"=>["36.744489819351", "36.744589819351", "-95.984237735312", "-95.984137735312"],
#     "lat"=>"36.7445398193508", "lon"=>"-95.9841877353121",
#     "display_name"=>"Bartlesville, Oklahoma, 74003, USA",
#     "class"=>"place",
#     "type"=>"postcode",
#     "importance"=>0.335,
#     "address"=>{"city"=>"Bartlesville", "state"=>"Oklahoma", "postcode"=>"74003", "country"=>"USA", "country_code"=>"us"}
#   },
#   @cache_hit=nil
# >

# <Hashie::Mash
#   apparentTemperature=95.46
#   cloudCover=0.43
#   dewPoint=75.57
#   humidity=0.71
#   icon="partly-cloudy-day"
#   nearestStormBearing=302
#   nearestStormDistance=0
#   ozone=310.2
#   precipIntensity=0
#   precipProbability=0
#   pressure=1018.05
#   summary="Humid and Partly Cloudy"
#   temperature=85.92
#   time=1561822569
#   uvIndex=5
#   visibility=10
#   windBearing=148
#   windGust=4.85
#   windSpeed=4.85
# >
