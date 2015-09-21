class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :from_barcode, Product

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
      can :delete, Order do |order|
        order.try(:user) == user && order.created_at > Rails.application.config.call_api_after.ago
      end
    end
  end
end
