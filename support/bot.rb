# frozen_string_literal: true

BOT = Discordrb::Commands::CommandBot.new(
    token: ENV['TOKEN'],
    client_id: ENV['CLIENT_ID'],
    prefix: '.'
)
