# frozen_string_literal: true

ALLOWED_SETTINGS = ['lastfm', 'location']

BOT.command :profile, description: 'Set or display profile information.' do |event, command, key, *value|
  value = value.join(' ')
  user = User.find_or_create(discord_id: event.author.id)
  case command
  when 'set'
    if ALLOWED_SETTINGS.include? key
      setting = user.settings_dataset.find_or_create(key: key) { |setting| setting.value = value }
      setting.update(value: value)
      'Profile Updated!'
    else
      'Unknown profile key, valid options are: ' + ALLOWED_SETTINGS.join(',')
    end
  else
    event.channel.send_embed do |embed|
      embed.color = event.author.colour
      embed.title = "Profile Settings for: #{event.author.name}"
      user.settings.each do |setting|
        embed.add_field(name: setting.key, value: setting.value)
      end
    end
  end
end
