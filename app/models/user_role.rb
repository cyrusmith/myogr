class UserRole
  include Mongoid::Document
  include Tenacity

  field :user_id, type: String
  field :roles, type: Array

  t_belongs_to :user

  ADMIN = :admin
  SALON_ADMINISTRATOR = :salon_admin
  DISTRIB_CENTER_MANAGER = :distrib_manager
  DISTRIB_CENTER_EMPLOYEE = :distrib_employee

end
