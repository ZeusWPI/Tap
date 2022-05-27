# frozen_string_literal: true

# Helpers for handeling ordering session
module OrderSessionHelper
  # Session versioning
  # If there are changes to the order session format they will break in production,
  # as the users would still have the old session stored, which no longer matches the new format.
  #
  # To prevent these errors a version is used, which will ignore older versions of the session.
  ORDER_SESSION_VERSION = "1.0"

  # Pop the order session from the session store and return it
  # @param [user] user to check if the order session belongs to
  def pop_order_session(user)
    # Retrieve the order session
    order_session_versions = session[:order] || {}
    order_session = order_session_versions[ORDER_SESSION_VERSION] || create_order_session(user, [])

    # Fix: https://stackoverflow.com/questions/23530055/ruby-on-rails-sneakily-changing-nested-hash-keys-from-symbols-to-strings
    # Session, stored internally or session retrieved from a cookie have a different form.
    # Rails, why you do this?
    order_session = order_session.symbolize_keys!

    # If the order session is owned by another user, delete the order session and create a new one.
    order_session = create_order_session(user, []) if order_session[:user_id] != user.id

    # Delete the order session from the session storage
    session.delete(:order)

    order_session
  end

  # Push the order session to the session store.
  # @param [user] user to check if the order session belongs to
  # @param [product_ids] list of product ids to add to the order
  def push_order_session(user, product_ids)
    # Create a new order session
    order_session = create_order_session(user, product_ids)

    # Store the order session
    session[:order][ORDER_SESSION_VERSION] = order_session
  end

  # Create a new order session
  # @param [user] user to check if the order session belongs to
  # @param [product_ids] list of product ids to add to the order
  def create_order_session(user, product_ids)
    session[:order] = {}
    session[:order][ORDER_SESSION_VERSION] = {
      user_id: user.id,
      product_ids: product_ids
    }

    session[:order][ORDER_SESSION_VERSION]
  end

  # Convert the order session to a string for usage as form field value.
  def stringify_order_session(order_session)
    order_session.to_json
  end

  # Convert the order session string into a valid order session hash.
  def parse_order_session(order_session_string)
    JSON.parse(order_session_string).symbolize_keys!
  end

  # Convert the order session into a string, base64 encoded for usage in URL.
  def base64_encode_order_session(order_session)
    Base64.encode64(stringify_order_session(order_session))
  end

  # Convert the order session string from URL into a valid order session hash.
  def base64_decode_order_session(order_session_string)
    parse_order_session(Base64.decode64(order_session_string))
  end
end
