require 'digest/md5'
module ApplicationHelper

  def get_color(user)
    @color = Digest::MD5.hexdigest(user.name)[0..5]
  end

  def get_inverted_color(user)
    @inverted_color = Digest::MD5.hexdigest(user.name)[0..5].reverse
  end

  def get_color_style(user)
    @style = "background-color: #"+ get_color(user) +"; color: #"+
    get_inverted_color(user)+ ";"
  end

  #tijdelijk voor layout
  def koelkast(status)
    @koelkast ||= status
  end


end
