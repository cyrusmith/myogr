module Distribution
  class Point
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    before_save :check_head_permission, :check_employees_permissions
    after_create :initialize_package_lists

    field :title, type: String
    field :head_user, type: Integer
    field :employees, type: Array
    field :default_day_package_limit, type: Integer, default: Distribution::Settings.day_package_limit
    field :comment, type: String

    embeds_one :address
    has_many :package_lists, class_name: 'Distribution::PackageList', inverse_of: :point, dependent: :destroy

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

    def get_marked_days(start_date=nil, num_months=3.month)
      start_date = start_date || Date.today.beginning_of_month
      start_date = Date.parse start_date unless start_date.is_a? Date
      range_package_lists = self.package_lists.where(:date.gte => start_date, :date.lte => start_date + num_months)
      days_off = range_package_lists.select { |list| list.is_day_off }.map { |list| {list.date => 'day-off'} }
      filled_package_lists = range_package_lists.select { |list| list.packages.not_case.count >= list.package_limit }.map{|list| {list.date => 'limit-filled'}}
      closed_package_lists = range_package_lists.select { |list| list.closed? }.map { |list| {list.date => 'closed'} }
      days_off + filled_package_lists + closed_package_lists
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

    def initialize_package_lists
      from = Date.today
      till = from + 90.days
      for current_date in from..till do
        self.package_lists << PackageList.create(date: current_date, package_limit: self.default_day_package_limit)
      end
    end

  end
end
