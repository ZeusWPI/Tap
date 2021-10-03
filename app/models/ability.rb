class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    # Special permissions for certain users
    initialize_admin    if user.admin?
    initialize_koelkast if user.koelkast?

    # Default permissions for all users
    initialize_user(user)
  end

  # Admin permissions
  def initialize_admin
    can :manage, Barcode
    can :manage, Product
    can :manage, Stock
    can :manage, User
  end

  # Regular user permissions
  def initialize_user(user)
    # The user can read all information (products, ...)
    can :read, :all

    # The user cannot read other users account/balance.
    cannot :read, User do |other_user|
      other_user != user
    end

    # The user can manage it's own account
    can :manage, User, id: user.id

    # A user can place an order if:
    # * The user is trying to place an order for himself
    # * The user has the appropriate balance for an order
    can :create, Order do |order|
      order.calculate_price
      order.try(:user) == user && user.try(:balance).try(:>=, order.price_cents)
    end

    # A user can delete an order if:
    # * The user is trying to delete an order for himself
    # * The order is still deletable (there is a specific time interval for deleting orders)
    can :destroy, Order do |order|
      order.try(:user) == user && order.deletable
    end
  end

  # "Koelkast" user permissions
  def initialize_koelkast
    # Koelkast can manage orders for users that have the following requirements:
    # * The user is not set to "private"
    # * The user has the appropriate balance for an order
    can :manage, Order do |order|
      order.calculate_price
      !order.try(:user).try(:private) && order.try(:user).try(:balance).try(:>=, order.price_cents)
    end

    # Koelkast can order a dagschotel for a user.
    # Since ordering a dagschotel uses the underlying order model,
    # the same rules as creating an order apply here.
    can :order_dagschotel, User
  end
end
