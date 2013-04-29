class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?
    case
      when user.has_role?(UserRole::ADMIN)
        can :manage, :all
      when user.has_role?(UserRole::DISTRIB_CENTER_MANAGER)
        can :access, Distribution::Point, :head_user => user.id
        cannot :destroy, Distribution::Point
        cannot :edit, Distribution::Point
      when user.has_role?(UserRole::SALON_ADMINISTRATOR)
        can :manage, Admin::Record
      else
        can :create, Banner
        can :manage, Record
        #TODO добавить условие на управления только своими записями
        can :manage, Distribution::Package
        can :read, Distribution::Point
    end
    #if
    #
    #elsif user.has_role? UserRole::DISTRIB_CENTER_MANAGER
    #  can :manage, DistributionCenter::DistributionCenter
    #
    #elsif user.has_role? UserRole::SALON_ADMINISTRATOR
    #  can :manage, Record
    #else
    #  can :create, Banner
    #  can :manage, Record
    #  can :read, DistributionCenter::DistributionCenter
    #end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
