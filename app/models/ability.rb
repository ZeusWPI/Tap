class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :schulden, :admins
    elsif user.koelkast?
      can :manage, Order
    elsif user[:id]
      can :read, :all
      can :update, User
      can :dagschotel, User
      can :create, Order
    end
  end
end
