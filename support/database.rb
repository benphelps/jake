# frozen_string_literal: true

DB = Sequel.connect('sqlite://jake.db')

# Load the migration extension and run migrations
Sequel.extension :migration
Sequel::Migrator.run(DB, File.join(__dir__, 'migrations'))

# Load models
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }
