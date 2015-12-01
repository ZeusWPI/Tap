module ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.map do |msg_type, message|
      content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)}") do
        content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' }) +
        content_tag(:strong, [msg_type.capitalize, "! "].join("")) +
        message
      end
    end.join().html_safe
  end

  def get_color(user)
    require 'digest/md5'
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
