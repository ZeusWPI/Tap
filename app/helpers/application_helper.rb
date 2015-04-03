require 'digest/md5'
module ApplicationHelper

  def get_color(user)
    Digest::MD5.hexdigest(user.nickname)[0..5]
  end

  def get_color_style(user)
    "background-color: \#"+ get_color(user) +";"
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
    postData = Net::HTTP.post_form(URI.parse('https://slack.com/api/users.list'), {'token'=>'xoxp-2484654576-2817526333-4116062828-04487a'})
    slackmember = JSON.parse(postData.body)["members"].select{ |m| m["profile"]["email"] == user.uid + "@zeus.ugent.be" }.first

    if slackmember
      Webhook.new(channel: "@" + slackmember["name"], username: "Tab").ping(message)
    end
  end
end
