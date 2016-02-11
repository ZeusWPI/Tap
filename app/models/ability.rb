class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    initialize_admin    if user.admin?
    initialize_koelkast if user.koelkast?
    initialize_user(user)

    can :read, Barcode
  end

  def initialize_admin
    can :manage, :all
  end

  def initialize_koelkast
    can :manage, Order do |order|
      !order.try(:user).try(:private)
    end
    can :quickpay, User
  end

  def initialize_user(user)
    can :read, :all
    can :manage, User, id: user.id
    can :create, Order do |order|
      order.user == user
    end
    can :destroy, Order do |order|
      order.try(:user) == user && order.deletable
    end
  end
end
