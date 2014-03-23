module Distribution
  class Point < ActiveRecord::Base
    include Tenacity
    include StElsewhere
    include Obtain
    include Transfer

    self.table_name_prefix = 'distribution_'

    delegate :short_address, :full_address, to: :address

    before_save :check_head_permission
    before_save :check_employees_permissions, unless: Proc.new { |point| point.points_users.nil? }
    after_create :initialize_package_lists

    attr_accessible :title, :head_user, :employee_ids,
                    :default_day_package_limit, :repeat_schedule, :autoaccept_point_id,
                    :phone, :address_attributes, :work_schedule

    validates :head_user, presence: true

    has_one :address, class_name: 'Location', as: :addressable, dependent: :destroy
    has_many :package_lists, :class_name => 'Distribution::PackageList', dependent: :destroy
    has_many :points_users, dependent: :destroy

    accepts_nested_attributes_for :address,
                                  reject_if: lambda { |a| a[:title].blank? and a[:head_user].blank? }

    def employee_ids=(values)
      if values.is_a? String
        values = values.split(/,/).map(&:to_i).reject{|v| v == 0}
      end
      values.each do |value|
        self.points_users.new(employee_id: value) unless self.points_users.find_by_employee_id(value)
      end
    end

    def employee_ids
      self.points_users.map(&:employee_id)
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

    def default_package_list_amount
      1
    end

    def short_address
      self.address.present? ? self.address.short_address : ''
    end

    private

    def check_head_permission
      user = User.find(self.head_user)
      user.add_role UserRole::DISTRIB_CENTER_MANAGER unless user.has_role? UserRole::DISTRIB_CENTER_MANAGER
    end

    def check_employees_permissions
      self.points_users.each do |pu|
        user = User.find pu.employee_id
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
