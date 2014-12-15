require 'csv'
class AdminsController < ApplicationController

  def schulden
    authorize! :schulden, :admins
    @users = User.all
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"zeus-schulden\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
