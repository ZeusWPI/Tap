class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@order = current_user.orders.build if logged_in?
  		@logs = current_user.feed.paginate(page: params[:page])
  	end
  end

  def overview
  	@users = User.all
  end

  def order
  end

  def help
  end
  
end
