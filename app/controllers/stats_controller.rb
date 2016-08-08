class StatsController < ApplicationController
  before_action :init

  def contributions
    render json: Hash[@user.orders.group_by(&:day).map{ |k,v| [k.strftime('%Y-%m-%d'), v.count] }]
  end

  private

    def init
      @user = current_user unless params[:id]
    end
end
