class Guest::OrdersController < OrdersController
  before_action :load_guest

  private

  def load_guest
    @user = User.guest
  end
end
