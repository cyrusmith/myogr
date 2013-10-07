module Distribution
  class Point < ActiveRecord::Base
    include Tenacity
    include StElsewhere

    self.table_name_prefix = 'distribution_'

    before_save :check_head_permission
    before_save :check_employees_permissions, unless: Proc.new { |point| point.employees.nil? }
    after_create :initialize_package_lists

    attr_accessible :title, :head_user, :employees, :head_name, :employees_names, :default_day_package_limit, :work_schedule, :phone, :address, :address_fields

    validates :head_user, presence: true

    has_one :address, as: :addressable, dependent: :destroy
    has_many :package_lists, :class_name => 'Distribution::PackageList', dependent: :destroy
    has_many :points_users
    has_many_elsewhere :employees, class_name: 'User', :through => :points_users

    accepts_nested_attributes_for :address,
                                  reject_if: lambda { |a| a[:title].blank? and a[:head_user].blank? }

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

    def get_days_info(exclude_filled_dates = false, options ={})
      start_date = options[:start_date] || Date.today.beginning_of_month
      start_date = Date.parse(start_date) unless start_date.is_a? Date
      num_months = options[:num_months] || 3.months
      admin_access = options[:admin_access]
      range_package_lists = self.package_lists.joins(:schedule).where(schedules: {date: start_date..(start_date+num_months)})
      info = []
      range_package_lists.each do |list|
        info << {list.date.iso8601 => list.get_info(exclude_filled_dates, admin_access)}
      end
      info
    end

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

    def initialize_package_lists
      from = Date.today
      till = from + 90.days
      for current_date in from..till do
        self.package_lists << PackageList.create(date: current_date, package_limit: self.default_day_package_limit)
      end
    end

  end
end
