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
    can :manage, Barcode
    can :manage, Product
    can :manage, Stock
    can :manage, User
  end

  def initialize_koelkast
    can :manage, Order do |order|
      order.calculate_price
      !order.try(:user).try(:private) && order.try(:user).try(:balance).try(:>=, order.price_cents)
    end
    can :quickpay, User
  end

  def initialize_user(user)
    can :read, :all
    cannot :read, User do |otheruser|
      otheruser != user && !user.koelkast
    end
    can :manage, User, id: user.id
    can :create, Order do |order|
      order.calculate_price
      order.user == user && user.try(:balance).try(:>=, order.price_cents)
    end
    can :destroy, Order do |order|
      order.try(:user) == user && order.deletable
    end
  end
end
