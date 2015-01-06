class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :schulden, :admins
    elsif user.koelkast?
      can :manage, Order
    else
      can :read, :all
    end
  end
end
