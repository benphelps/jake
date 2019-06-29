# frozen_string_literal: true

lastfm = Lastfm.new(ENV['LASTFM_KEY'], ENV['LASTFM_SECRET'])

BOT.command :lastfm, aliases: [:np] do |event, text|
  user = User.find_or_create(discord_id: event.author.id)
  lastfm_username = user.settings_dataset.first(key: 'lastfm')&.value

  if lastfm_username
    lastfm_user = lastfm.user.get_info(user: lastfm_username)
    latest = lastfm.user.get_recent_tracks(user: lastfm_username, limit: 1)
    user_info = lastfm.track.get_info(track: latest['name'], artist: latest['artist']['content'], user: lastfm_username)
    event.channel.send_embed do |embed|
      embed.url = latest['url']
      embed.timestamp = Time.at(latest['date']['uts'].to_i)
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: latest['image'].last['content'])
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Scrobbled", icon_url: "https://www.last.fm/static/images/lastfm_avatar_twitter.66cd2c48ce03.png")
      embed.add_field(name: "Track", value: latest['name'], inline: true)
      embed.add_field(name: "Album", value: latest['album']['content'], inline: true)
      embed.add_field(name: "Artist", value: latest['artist']['content'], inline: true)
      embed.add_field(name: "Play Count", value: user_info['userplaycount'], inline: true)
    end
  else
    'Please set your Last.fm username using `.profile set lastfm <username>`'
  end
  
end

# {
#   "artist"=>{
#     "mbid"=>"373a4c98-a46b-48e4-86ec-f6ca65b4f438",
#     "content"=>"Chance the Rapper"
#   },
#   "name"=>"All We Got (feat. Kanye West & Chicago Children's Choir)",
#   "streamable"=>"0",
#   "mbid"=>{},
#   "album"=>{
#     "mbid"=>"477d264f-9835-48d7-8fd5-aabe19a8c135",
#     "content"=>"Coloring Book"
#   },
#   "url"=>"https://www.last.fm/music/Chance+the+Rapper/_/All+We+Got+(feat.+Kanye+West+&+Chicago+Children%27s+Choir)",
#   "image"=>[
#     {"size"=>"small", "content"=>"https://lastfm-img2.akamaized.net/i/u/34s/15b37232ffad3490370868c68f76c730.png"},
#     {"size"=>"medium", "content"=>"https://lastfm-img2.akamaized.net/i/u/64s/15b37232ffad3490370868c68f76c730.png"},
#     {"size"=>"large", "content"=>"https://lastfm-img2.akamaized.net/i/u/174s/15b37232ffad3490370868c68f76c730.png"},
#     {"size"=>"extralarge", "content"=>"https://lastfm-img2.akamaized.net/i/u/300x300/15b37232ffad3490370868c68f76c730.png"}
#   ],
#   "date"=>{
#     "uts"=>"1561817127",
#     "content"=>"29 Jun 2019, 14:05"
#   }
# }

# {
#   "name"=>"All We Got (feat. Kanye West & Chicago Children's Choir)",
#   "url"=>"https://www.last.fm/music/Chance+the+Rapper/_/All+We+Got+(feat.+Kanye+West+&+Chicago+Children%27s+Choir)",
#   "duration"=>"203000",
#   "streamable"=>{
#     "fulltrack"=>"0",
#     "content"=>"0"
#   },
#   "listeners"=>"102939",
#   "playcount"=>"538308",
#   "artist"=>{
#     "name"=>"Chance the Rapper",
#     "mbid"=>"373a4c98-a46b-48e4-86ec-f6ca65b4f438",
#     "url"=>"https://www.last.fm/music/Chance+the+Rapper"
#   },
#   "userplaycount"=>"15",
#   "userloved"=>"0",
#   "toptags"=>{
#     "tag"=>[
#       {"name"=>"Hip-Hop", "url"=>"https://www.last.fm/tag/Hip-Hop"},
#       {"name"=>"choir", "url"=>"https://www.last.fm/tag/choir"},
#       {"name"=>"Kanye West", "url"=>"https://www.last.fm/tag/Kanye+West"},
#       {"name"=>"kanye", "url"=>"https://www.last.fm/tag/kanye"},
#       {"name"=>"auto-tune", "url"=>"https://www.last.fm/tag/auto-tune"}
#     ]
#   }
# }
