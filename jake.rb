# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Dotenv.load

Dir[File.join(__dir__, 'support', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'database', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'commands', '*.rb')].each { |file| require file }

BOT.run
