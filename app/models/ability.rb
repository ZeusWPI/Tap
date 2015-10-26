class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :read, Barcode

    if user.admin?
      can :manage, :all
    elsif user.koelkast?
      can :manage, Order do |order|
        !order.try(:user).try(:private)
      end
      can :quickpay, User
    else
      can :read, :all
      can :manage, User, id: user.id
      can :create, Order do |order|
        order.try(:user) == user
      end
      can :destroy, Order do |order|
        order.try(:user) == user && order.deletable
      end
    end
  end
end
