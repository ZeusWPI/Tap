class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.koelkast?
      can :manage, Order
    elsif user[:id]
      can :read, :all
      can :manage, User, id: user.id
      can :manage, Order do |order|
        order.try(:user) == user
      end
    end
  end
end
