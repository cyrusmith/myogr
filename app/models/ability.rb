class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?
    if user.has_role?(UserRole::ADMIN)
      can :manage, :all
    elsif user.has_role?(UserRole::DISTRIB_CENTER_MANAGER)
      can :access, Distribution::Point, :head_user => user.id
      can :view_list, Distribution::Point
      can :read, Distribution::Point
      cannot :destroy, Distribution::Point
      cannot :edit, Distribution::Point
      can :manage, Distribution::PackageList
      can :manage, Distribution::Package
    elsif user.has_role?(UserRole::SALON_ADMINISTRATOR)
      can :manage, Admin::Record
    else
      can :create, Banner
      can :manage, Record
      can :manage, Distribution::Package, :user_id => user.id
      can :read, Distribution::Point
    end
  end
end
