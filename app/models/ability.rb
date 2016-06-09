class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Barcode
    can :read, Product
    can :manage, :all

    return unless user

    initialize_admin    if user.admin?
    initialize_koelkast if user.koelkast?
    initialize_user(user)

  end

  def initialize_admin
    can :manage, :all
  end

  def initialize_koelkast
    can :create, Order
    cannot :create, Order, user: { private: true }
    cannot :create, Order do |order|
      order.try(:user).try(:balance).try(:<, Rails.application.config.x.balance_cap)
    end

    can :quickpay, User
  end

  def initialize_user(user)
    can :manage, user

    can :create, Order, user: user unless user.balance.try(:<, Rails.application.config.x.balance_cap)
    can :destroy, Order, user: user
    cannot :destroy, Order do |order|
      !order.deletable
    end
  end
end
