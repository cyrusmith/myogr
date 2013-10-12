class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?
    if user.has_role?(UserRole::ADMIN)
      can :manage, :all
    elsif user.has_role?(UserRole::DISTRIB_CENTER_MANAGER) || user.has_role?(UserRole::DISTRIB_CENTER_EMPLOYEE)
      can :access, Distribution::Point, :head_user => user.id
      can :view_list, Distribution::Point
      can :read, Distribution::Point
      cannot :destroy, Distribution::Point
      cannot :edit, Distribution::Point
      can :manage, Distribution::PackageList
      can :manage, Distribution::Package
      can :manage, Distribution::Barcode
      can :manage, :order
    elsif user.has_role?(UserRole::SALON_ADMINISTRATOR)
      can :manage, Admin::Record
    else
      can :create, Banner
      can :manage, Record
      can :manage, :order
      can :manage, Distribution::Package, :user_id => user.id
      can :manage, Distribution::Barcode, :owner => user.id
      can :create, Distribution::PackageItem
      can :read, Distribution::Point
    end
  end
end
