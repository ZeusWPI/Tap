class Api::V1::OrdersController < OrdersController
  skip_before_action :verify_authenticity_token, only: :create
end
