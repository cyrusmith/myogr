module DistributionCenter
  class DistributionCenter
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    store_in collection: 'distribution_centers'

    before_save :check_head_permission, :check_employees_permissions

    field :title, type: String
    field :head_user, type: Integer
    field :employees, type: Array
    field :default_day_package_limit, type: Integer, default: Settings.day_package_limit
    field :comment, type: String

    embeds_one :address
    has_many :distribution_center_package_lists, :class_name => 'DistributionCenter::PackageList'

    attr_accessible :title, :head_name, :employees_names, :default_day_package_limit, :comment, :address, :address_fields

    def head_name
      User.find(self.head_user).try :display_name if self.head_user.present?
    end

    def head_name=(name)
      self.head_user=User.find_by_members_display_name(name).id if name.present?
    end

    def employees_names
      self.employees.map { |employee| User.find(employee).try :display_name }.to_sentence(two_words_connector: ', ', last_word_connector: ', ') if self.employees.present?
    end

    def employees_names=(names)
      array = names.split(/,/).delete_if { |c| c.blank? }.uniq
      self.employees = array.map { |name| User.find_by_members_display_name(name.strip).try(:id) }.delete_if { |x| x.nil? }
    end

    accepts_nested_attributes_for :address,
                                  reject_if: lambda { |a| a[:title].blank? and a[:head_user].blank? }


    private

    def check_head_permission
      user = User.find(self.head_user)
      user.add_role UserRole::DISTRIB_CENTER_MANAGER unless user.has_role? UserRole::DISTRIB_CENTER_MANAGER
    end

    def check_employees_permissions
      self.employees.each do |employee|
        user = User.find employee
        user.add_role UserRole::DISTRIB_CENTER_EMPLOYEE unless user.has_role?(UserRole::DISTRIB_CENTER_EMPLOYEE)
      end
    end

  end
end