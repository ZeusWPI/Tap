# frozen_string_literal: true

module Guest
  class OrdersController < OrdersController
    before_action :load_guest

    private

    def load_guest
      @user = User.guest
    end
  end
end
