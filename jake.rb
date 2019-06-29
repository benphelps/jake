# frozen_string_literal: true

require 'discordrb'
require 'dotenv'
require 'sequel'

Dotenv.load
Dir[File.join(__dir__, 'support', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'commands', '*.rb')].each { |file| require file }
BOT.run
