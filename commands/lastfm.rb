# frozen_string_literal: true

RSpotify.authenticate(ENV['SPOTIFY_ID'], ENV['SPOTIFY_SECRET'])
lastfm = Lastfm.new(ENV['LASTFM_KEY'], ENV['LASTFM_SECRET'])
lastfm_icon_url = 'https://www.last.fm/static/images/lastfm_avatar_twitter.66cd2c48ce03.png'

BOT.command :lastfm, aliases: [:np, :n], description: 'Display now playinf information for your profiles Last.fm username.' do |event, lookup|
  if lookup
    lastfm_username = lookup
  else
    user = User.find_or_create(discord_id: event.author.id)
    lastfm_username = user.settings_dataset.first(key: 'lastfm')&.value
  end

  if lastfm_username
    lastfm_user = lastfm.user.get_info(user: lastfm_username)
    latest = lastfm.user.get_recent_tracks(user: lastfm_username, limit: 1)
    latest = latest.first if latest.is_a? Array
    if latest
      track = RSpotify::Track.search("#{latest['name']} - #{latest['artist']['content']}").first
      user_info = lastfm.track.get_info(track: latest['name'], artist: latest['artist']['content'], user: lastfm_username)
      event.channel.send_embed do |embed|
        embed.color = event.author.colour
        if track.external_urls['spotify']
          embed.title = 'Listen on Spotify'
          embed.url = track.external_urls['spotify']
        else
          embed.url = latest['url']
        end
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: latest['image'].last['content'])
        if latest['date']
          embed.timestamp = Time.at(latest['date']['uts'].to_i)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Scrobbled', icon_url: lastfm_icon_url)
        else
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Listening now', icon_url: lastfm_icon_url)
        end
        embed.add_field(name: 'Track', value: latest['name'], inline: true)
        embed.add_field(name: 'Album', value: latest['album']['content'], inline: true)
        embed.add_field(name: 'Artist', value: latest['artist']['content'], inline: true)
        embed.add_field(name: 'Play Count', value: user_info['userplaycount'], inline: true)
      end
    else
      "Couldn't find last playing information :("
    end
  else
    "No Last.fm username provided, set using `#{BOT.prefix}profile set lastfm <username>`"
  end
end

# <RSpotify::Track:0x00007f8f4b265c28
#   @available_markets=[...],
#   @disc_number=1,
#   @duration_ms=221893,
#   @explicit=true,
#   @external_ids={"isrc"=>"CAUM71600228"},
#   @uri="spotify:track:4LP2VeYnQCW8FpsUztef2Y",
#   @name="• TEMPTED",
#   @popularity=48,
#   @preview_url=nil,
#   @track_number=1,
#   @played_at=nil,
#   @context_type=nil,
#   @is_playable=nil,
#   @album=#<RSpotify::Album:0x00007f8f4b26e300
#     @album_type="single",
#     @available_markets=[...],
#     @copyrights=nil,
#     @external_ids=nil,
#     @genres=nil,
#     @images=[
#       {"height"=>640, "url"=>"https://i.scdn.co/image/6f648b33e21225a4bd084c82e5fcded12494aa82", "width"=>640},
#       {"height"=>300, "url"=>"https://i.scdn.co/image/f96822864c122b812e77a0f22f6e596ef9d4f9fe", "width"=>300},
#       {"height"=>64, "url"=>"https://i.scdn.co/image/4940ee3ed63d1b58aed84c7b2767266cbb5db1f8", "width"=>64}
#     ],
#     @label=nil,
#     @name="Tempted",
#     @popularity=nil,
#     @release_date="2017-01-03",
#     @release_date_precision="day",
#     @artists=[
#       #<RSpotify::Artist:0x00007f8f4b277018
#         @followers=nil,
#         @genres=nil,
#         @images=nil,
#         @name="Jazz Cartier",
#         @popularity=nil,
#         @top_tracks={},
#         @external_urls={
#           "spotify"=>"https://open.spotify.com/artist/0sc5zYshOdiFD4ayqMrJbJ"
#         },
#         @href="https://api.spotify.com/v1/artists/0sc5zYshOdiFD4ayqMrJbJ",
#         @id="0sc5zYshOdiFD4ayqMrJbJ",
#         @type="artist",
#         @uri="spotify:artist:0sc5zYshOdiFD4ayqMrJbJ"
#       >
#     ],
#     @tracks_cache=nil,
#     @total_tracks=nil,
#     @external_urls={
#       "spotify"=>"https://open.spotify.com/album/5HWjlVQWHSgSd21CJ1u7OK"
#     },
#     @href="https://api.spotify.com/v1/albums/5HWjlVQWHSgSd21CJ1u7OK",
#     @id="5HWjlVQWHSgSd21CJ1u7OK",
#     @type="album",
#     @uri="spotify:album:5HWjlVQWHSgSd21CJ1u7OK"
#   >,
#   @artists=[
#     #<RSpotify::Artist:0x00007f8f4b277018
#       @followers=nil,
#       @genres=nil,
#       @images=nil,
#       @name="Jazz Cartier",
#       @popularity=nil,
#       @top_tracks={},
#       @external_urls={
#         "spotify"=>"https://open.spotify.com/artist/0sc5zYshOdiFD4ayqMrJbJ"
#       },
#       @href="https://api.spotify.com/v1/artists/0sc5zYshOdiFD4ayqMrJbJ",
#       @id="0sc5zYshOdiFD4ayqMrJbJ",
#       @type="artist",
#       @uri="spotify:artist:0sc5zYshOdiFD4ayqMrJbJ"
#     >
#   ],
#   @linked_from=nil,
#   @external_urls={
#     "spotify"=>"https://open.spotify.com/track/4LP2VeYnQCW8FpsUztef2Y"
#   },
#   @href="https://api.spotify.com/v1/tracks/4LP2VeYnQCW8FpsUztef2Y",
#   @id="4LP2VeYnQCW8FpsUztef2Y",
#   @type="track"
# >

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
