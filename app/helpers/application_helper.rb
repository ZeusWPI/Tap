module ApplicationHelper
  include ActionView::Helpers::NumberHelper

  # Get the Bulma notification class for a given flash type
  def flash_class(flash_type)
    types = {
      success: "is-success",
      error: "is-danger",
      alert: "is-warning",
      info: "is-info"
    }

    types[flash_type.to_sym] || "is-info"
  end

  # Convert a given user name to a color hash
  # Only user dark colors for contrast.
  def get_user_color(user)
    require "digest/md5"
    "#" + Digest::MD5.hexdigest(user.name)[0..5]
  end

  ## Convert a given user to a color hash for the text
  def get_user_text_color(user)
    user_color = get_user_color(user).gsub("#", "")

    # Get the hex color as red, green, blue
    r = user_color[0..1].hex
    g = user_color[2..3].hex
    b = user_color[4..5].hex

    if ((r * 0.299) + (g * 0.587) + (b * 0.114)) > 186
      "#4a4a4a"
    else
      "#ffffff"
    end
  end

  # Convert a given users balance into a color hash
  # If the user has a positive balance, use green
  # If the user has a negative balance, use red
  def get_user_balance_color(user)
    if user.balance > 0
      "#257942"
    else
      "#cc0f35"
    end
  end

  # Convert a given float in cents to euro's in a formatted string.
  def euro_from_cents(f)
    if f
      euro(f / 100.0)
    else
      "undefined"
    end
  end

  # Convert a given float in euro's to a formatted string.
  def euro(f)
    number_to_currency(f, unit: "€")
  end

  # Replace all instances of double quotes with single quotes
  # This can be useful for escaping strings in HTML
  def escape_quotes(str)
    str.gsub("\"", "'")
  end

  # Create a formatted form.
  def f_form_for(record, options = {}, &block)
    options[:builder] = FormattedFormBuilder
    form_for(record, options, &block)
  end

  # Create a formatted form
  def f_form_with(**options, &block)
    options[:builder] = FormattedFormBuilder
    form_with(**options, &block)
  end

  # Get the Tab URL
  def tab_url
    Rails.application.config.api_url
  end

  # Get the current theme of the user
  def theme
    {
      variant: {
        name: cookies[:themeVariantName],
        hue: cookies[:themeVariantHue]
      },
      mode: cookies[:themeMode] || "light"
    }
  end
end
