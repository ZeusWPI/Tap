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
end
