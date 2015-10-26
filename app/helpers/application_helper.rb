require 'digest/md5'
module ApplicationHelper

  def get_color(user)
    Digest::MD5.hexdigest(user.name)[0..5]
  end

  def get_color_style(user)
    "background-color: \#"+ get_color(user) +";"
  end

  def euro_from_cents(f)
    if f
      euro(f / 100.0)
    else
      "undefined"
    end
  end

  def euro(f)
    number_to_currency(f, unit: '€')
  end

  def f_form_for(record, options = {}, &block)
    options[:builder] = FormattedFormBuilder
    form_for(record, options, &block)
  end

  def slack_notification(user, message)
    require 'net/http'
    require 'json'
    postData = Net::HTTP.post_form(URI.parse('https://slack.com/api/users.list'), {'token'=>Rails.application.secrets.access_token})
    data = JSON.parse(postData.body)
    if data["ok"]
      slackmember = data["members"].select{ |m| m["profile"]["email"] == user.name + "@zeus.ugent.be" }.first

      if slackmember
        Webhook.new(channel: "@" + slackmember["name"], username: "Tab").ping(message)
      end
    end
  end
end
