# frozen_string_literal: true

client = IEX::Api::Client.new(
  publishable_token: ENV['IEX_TOKEN'],
  endpoint: ENV['IEX_ENDPOINT']
)

def number_to_currency(number)
  ActionView::Base.new.number_to_currency number
end

BOT.command :stock, aliases: [:quote, :q], description: 'Lookup current stock prices for the given symbol.' do |event, symbol|
  company = client.company(symbol)
  if company
    logo = client.logo(company.symbol)
    quote = client.quote(company.symbol)
    event.channel.send_embed do |embed|
      embed.color = event.author.colour
      embed.title = company.company_name
      embed.url = company.website if company.website
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: logo.url) if logo&.url
      embed.timestamp = Time.at((quote.latest_update / 1000).to_i)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: company.exchange)
      embed.add_field(name: "Price", value: number_to_currency(quote.latest_price), inline: true)
      embed.add_field(name: "Change", value: quote.change_percent_s, inline: true)
      embed.add_field(name: "High", value: number_to_currency(quote.high), inline: true)
      embed.add_field(name: "Low", value: number_to_currency(quote.low), inline: true)
    end
  else
    'Couldn\'t find that company'
  end
end

# <IEX::Resources::Company
#   ceo="Satya Nadella"
#   company_name="Microsoft Corp."
#   description="Microsoft Corp. engages in the development and support of software, services, devices, and solutions. Its products includes operating systems; cross-device productivity applications; server applications; business solution applications; desktop and server management tools; software development tools; and video games. It also offers personal computers, tablets, gaming and entertainment consoles, other intelligent devices, and related accessories. It operates through the following business segments: Productivity and Business Processes; Intelligent Cloud; and More Personal Computing. The Productivity and Business Processes segment is comprised of products and services in the portfolio of productivity, communication, and information services of the company spanning a variety of devices and platform. The Intelligent Cloud segment refers to the public, private, and hybrid serve products and cloud services of the company which can power modern business. The More Personal Computing segment encompasses the products and services such as windows operating system, devices, gaming platform, and search engines. The company was founded by William Henry Gates III in 1975 and is headquartered in Redmond, WA."
#   employees=131000
#   exchange="NASDAQ"
#   industry="Packaged Software"
#   issue_type="cs"
#   sector="Technology Services"
#   security_name="Microsoft Corporation"
#   symbol="MSFT"
#   website="http://www.microsoft.com"
# >

# <IEX::Resources::Logo
#   url="https://storage.googleapis.com/iex/api/logos/MSFT.png"
# >

# <IEX::Resources::OHLC
#   close=<IEX::Resources::OHLC::TimedPrice
#           price=133.96
#           time=2019-06-28 23:00:00 +0300
#         >
#   high=134.6
#   low=133.156
#   open=<IEX::Resources::OHLC::TimedPrice
#           price=134.53
#           time=2019-06-28 16:30:00 +0300
#        >
# >

# <IEX::Resources::Quote
#   avg_total_volume=23852890
#   calculation_price="close"
#   change=-0.19
#   change_percent=-0.00142
#   change_percent_s="-0.14%"
#   close=133.96
#   close_time=1561752000944
#   company_name="Microsoft Corp."
#   delayed_price=133.97
#   delayed_price_time=1561751739211
#   extended_price=134.2
#   extended_price_time=1561852707357
#   high=134.6
#   iex_ask_price=nil
#   iex_ask_size=nil
#   iex_bid_price=nil
#   iex_bid_size=nil
#   iex_last_updated=nil
#   iex_last_updated_t=nil
#   iex_market_percent=nil
#   iex_realtime_price=nil
#   iex_realtime_size=nil
#   iex_volume=nil
#   latest_price=133.96
#   latest_source="Close"
#   latest_time="June 28, 2019"
#   latest_update=1561752000944
#   latest_update_t=2019-06-28 23:00:00 +0300
#   latest_volume=30018705
#   low=133.156
#   market_cap=1026511367200
#   open=134.53
#   open_time=1561728600162
#   pe_ratio=29.51
#   previous_close=134.15
#   symbol="MSFT"
#   week_52_high=138.4
#   week_52_low=93.96
#   ytd_change=0.32334300000000005
# >
