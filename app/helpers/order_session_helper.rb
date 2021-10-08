# Helpers for handeling ordering session
#
# When a user is building an order the state is stored inside the session storage.
# This is done to prevent giant forms from being generated which causes delay on both the server and client.
# This helper is used to store and retrieve the state of the order.
module OrderSessionHelper
  # Session versioning
  # If there are changes to the order session format they will break in production,
  # as the users would still have the old session stored, which no longer matches the new format.
  #
  # To prevent these errors a version is used, which will ignore older versions of the session.
  ORDER_SESSION_VERSION = '1.0'

  # Get the order session from the session storage for a given user.
  # If the order session does not exist, an empty order session will be created.
  # If the order session exists, but is owned by another user, delete the order session and create a new one.
  # (this can be the case when ordering from Koelkast)
  def get_order_session(user)
    order_session_versions = session[:order] || {}
    order_session = order_session_versions[ORDER_SESSION_VERSION]

    # Create a new order session if it does not exist
    if not order_session
      create_order_session(user)

    # If the order session is owned by another user, delete the order session and create a new one.
    elsif order_session[:user_id] != user.id
      delete_order_session()
      create_order_session(user)

    # Otherwise: return the existing order session
    else
      order_session
    end
  end

  # Create a new order session for a given user.
  # Will override any existing order session.
  def create_order_session(user)
    session[:order] = {}
    session[:order][ORDER_SESSION_VERSION] = {
      user_id: user.id,
      items: []
    }
  end

  # Delete the current order session
  def delete_order_session()
    session[:order] = {}
  end
end
