module OrdersHelper

    def ordering(user)
      session[:order_user_id] = user.id
    end

    def current_ordering_user
      @current_ordering_user ||= User.find_by(id: session[:order_user_id])
    end

    def end_order
      session.delete(:order_user_id)
      @current_ordering_user = nil
    end

    def ordering?
      !current_ordering_user.nil?
    end

end
