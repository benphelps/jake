# frozen_string_literal: true

def format_mana(text)
  text.sub! '{W}', '<:manaw:524401508909842443>'
  text.sub! '{U}', '<:manau:524401508784013322>'
  text.sub! '{B}', '<:manab:524401508712972318>'
  text.sub! '{R}', '<:manar:524401508813373470>'
  text.sub! '{G}', '<:manag:524401508863836170>'
  text.sub! '{C}', '<:manac:524401508767367169>'
  text.sub! '{W/U}', '<:manawu:524401508637212676>'
  text.sub! '{W/B}', '<:manawb:524401508339548194>'
  text.sub! '{B/R}', '<:manabr:524401508754915338>'
  text.sub! '{B/G}', '<:manabg:524401508750589953>'
  text.sub! '{U/B}', '<:manaub:524401508536680454>'
  text.sub! '{U/R}', '<:manaur:524401508360650813>'
  text.sub! '{R/G}', '<:manarg:524401508754653204>'
  text.sub! '{R/W}', '<:manarw:524401508389879816>'
  text.sub! '{G/W}', '<:managw:524401508704321546>'
  text.sub! '{G/U}', '<:managu:524401508759109658>'
  text.sub! '{0}', '<:mana0:524401508482154515>'
  text.sub! '{1}', '<:mana1:524401508356456500>'
  text.sub! '{2}', '<:mana2:524401508494606352>'
  text.sub! '{3}', '<:mana3:524401508339548171>'
  text.sub! '{4}', '<:mana4:524401508779819008>'
  text.sub! '{5}', '<:mana5:524401509505564683>'
  text.sub! '{6}', '<:mana6:524401508771561472>'
  text.sub! '{7}', '<:mana7:524401508725293057>'
  text.sub! '{8}', '<:mana8:524401508725555200>'
  text.sub! '{9}', '<:mana9:524401508666703892>'
  text.sub! '{10}', '<:mana10:524401508733681674>'
  text.sub! '{11}', '<:mana11:524401508821762049>'
  text.sub! '{12}', '<:mana12:524401508884938772>'
  text.sub! '{13}', '<:mana13:524401508721229843>'
  text.sub! '{14}', '<:mana14:524401508524097537>'
  text.sub! '{15}', '<:mana15:524401508725555210>'
  text.sub! '{16}', '<:mana16:524401508368908295>'
  text.sub! '{17}', '<:mana17:524401508582948895>'
  text.sub! '{18}', '<:mana18:524401508666703872>'
  text.sub! '{19}', '<:mana19:524401508813373460>'
  text.sub! '{20}', '<:mana20:524401508624760843>'
  text.sub! '{X}', '<:manax:524401508675223563>'
  text.sub! '{Y}', '<:manay:524401508448600066>'
  text.sub! '{Z}', '<:manaz:524401508704452621>'
  text.sub! '{Q}', '<:manaq:524401508377165826>'
  text
end

BOT.command :mtg, description: 'Searches the Skryfall MTG card database' do |event, *text|
  search = text.join(' ')
  result = Scryfall::Cards.named_fuzzy search

  if result['object'] == 'error'
    return result['details']
  elsif result['object'] == 'card'
    event.channel.send_embed do |embed|
      embed.color = event.author.colour
      embed.title = result['name'] + ' ' + format_mana(result['mana_cost'])
      embed.url = result['related_uris']['gatherer']
      embed.description = result['oracle_text']
      if result['image_uris'] && result['image_uris']['png']
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: result['image_uris']['png'])
      end
    end
  else
    return 'I dunno man, what even is a card?'
  end
end

# {
#                "object" => "card",
#                    "id" => "bf5a0e1e-5239-41f3-a63f-d9303b1b01fc",
#             "oracle_id" => "a9d288b8-cdc1-4e55-a0c9-d6edfc95e65d",
#        "multiverse_ids" => [
#         [0] 447292
#     ],
#               "mtgo_id" => 68473,
#              "arena_id" => 67992,
#          "tcgplayer_id" => 168475,
#                  "name" => "Shock",
#                  "lang" => "en",
#           "released_at" => "2018-07-13",
#                   "uri" => "https://api.scryfall.com/cards/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc",
#          "scryfall_uri" => "https://scryfall.com/card/m19/156/shock?utm_source=api",
#                "layout" => "normal",
#         "highres_image" => true,
#            "image_uris" => {
#               "small" => "https://img.scryfall.com/cards/small/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.jpg?1562303926",
#              "normal" => "https://img.scryfall.com/cards/normal/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.jpg?1562303926",
#               "large" => "https://img.scryfall.com/cards/large/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.jpg?1562303926",
#                 "png" => "https://img.scryfall.com/cards/png/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.png?1562303926",
#            "art_crop" => "https://img.scryfall.com/cards/art_crop/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.jpg?1562303926",
#         "border_crop" => "https://img.scryfall.com/cards/border_crop/front/b/f/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc.jpg?1562303926"
#     },
#             "mana_cost" => "{R}",
#                   "cmc" => 1.0,
#             "type_line" => "Instant",
#           "oracle_text" => "Shock deals 2 damage to any target.",
#                "colors" => [
#         [0] "R"
#     ],
#        "color_identity" => [
#         [0] "R"
#     ],
#            "legalities" => {
#          "standard" => "legal",
#            "future" => "legal",
#          "frontier" => "legal",
#            "modern" => "legal",
#            "legacy" => "legal",
#            "pauper" => "legal",
#           "vintage" => "legal",
#             "penny" => "not_legal",
#         "commander" => "legal",
#              "duel" => "legal",
#         "oldschool" => "not_legal"
#     },
#                 "games" => [
#         [0] "arena",
#         [1] "mtgo",
#         [2] "paper"
#     ],
#              "reserved" => false,
#                  "foil" => true,
#               "nonfoil" => true,
#             "oversized" => false,
#                 "promo" => false,
#               "reprint" => true,
#             "variation" => false,
#                   "set" => "m19",
#              "set_name" => "Core Set 2019",
#              "set_type" => "core",
#               "set_uri" => "https://api.scryfall.com/sets/2f5f2509-56db-414d-9a7e-6e312ec3760c",
#        "set_search_uri" => "https://api.scryfall.com/cards/search?order=set&q=e%3Am19&unique=prints",
#      "scryfall_set_uri" => "https://scryfall.com/sets/m19?utm_source=api",
#           "rulings_uri" => "https://api.scryfall.com/cards/bf5a0e1e-5239-41f3-a63f-d9303b1b01fc/rulings",
#     "prints_search_uri" => "https://api.scryfall.com/cards/search?order=released&q=oracleid%3Aa9d288b8-cdc1-4e55-a0c9-d6edfc95e65d&unique=prints",
#      "collector_number" => "156",
#               "digital" => false,
#                "rarity" => "common",
#           "flavor_text" => "The tools of invention became the weapons of revolution.",
#       "illustration_id" => "167dac35-21f6-4174-b496-4b66ffd980b1",
#          "card_back_id" => "0aeebaf5-8c7d-4636-9e82-8c27447861f7",
#                "artist" => "Jason Rainville",
#          "border_color" => "black",
#                 "frame" => "2015",
#              "full_art" => false,
#              "textless" => false,
#               "booster" => true,
#       "story_spotlight" => false,
#           "edhrec_rank" => 4001,
#                "prices" => {
#              "usd" => "0.12",
#         "usd_foil" => "1.30",
#              "eur" => "0.07",
#              "tix" => "0.04"
#     },
#          "related_uris" => {
#                "gatherer" => "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=447292",
#         "tcgplayer_decks" => "https://decks.tcgplayer.com/magic/deck/search?contains=Shock&page=1&partner=Scryfall&utm_campaign=affiliate&utm_medium=scryfall&utm_source=scryfall",
#                  "edhrec" => "http://edhrec.com/route/?cc=Shock",
#                 "mtgtop8" => "https://mtgtop8.com/search?MD_check=1&SB_check=1&cards=Shock"
#     },
#         "purchase_uris" => {
#           "tcgplayer" => "https://shop.tcgplayer.com/product/productsearch?id=168475&partner=Scryfall&utm_campaign=affiliate&utm_medium=scryfall&utm_source=scryfall",
#          "cardmarket" => "https://www.cardmarket.com/en/Magic/Products/Singles/Core-2019/Shock?referrer=scryfall&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall",
#         "cardhoarder" => "https://www.cardhoarder.com/cards/68473?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall"
#     }
# }

# {
#      "object" => "error",
#        "code" => "not_found",
#      "status" => 404,
#     "details" => "No cards found matching “aust commd”"
# }


# {
#      "object" => "error",
#        "code" => "not_found",
#        "type" => "ambiguous",
#      "status" => 404,
#     "details" => "Too many cards match ambiguous name “Ashen”. Add more words to refine your search."
# }
