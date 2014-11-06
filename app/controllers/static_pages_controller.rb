class StaticPagesController < ApplicationController
  def home
  end

  def overview
  	@users = User.all
  end

  def order
  end
end
