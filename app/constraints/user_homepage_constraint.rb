class UserHomepageConstraint < Struct.new(:role)
  def matches?(request)
    role == request.env['warden'].user.koelkast?
  end
end
