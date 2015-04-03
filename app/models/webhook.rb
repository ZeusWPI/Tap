class Webhook
  DEFAULT_USERNAME = "Tab"

  attr_accessor :hook

  def initialize(attributes = {})
    options = {
      channel:    (attributes[:channel]),
      username:   (attributes[:username] || DEFAULT_USERNAME),
      icon_url:   attributes[:icon_url],
      icon_emoji: attributes[:icon_emoji]
    }

    self.hook = Tarumi::Bot.new(
      Tab002::ZEUS_TEAM,
      Tab002::ZEUS_TOKEN,
      options
    )
  end

  def ping(text)
    self.hook.ping(text)
  end
end
