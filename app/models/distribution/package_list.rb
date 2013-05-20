module Distribution
  class PackageList < ::Schedule
    include Mongoid::Document

    before_save :check_package_limit

    field :package_limit, type: Integer
    field :is_closed, type: Boolean, default: false
    field :closed_by, type: String

    state_machine :state, :initial => :forming do
      event :to_collecting do
        transition :forming => :collecting
      end
      #TODO тут кроется потенциальный глюк, так как транзакций в монго нет, а операции атомарны только в рамках одного объекта.
      after_transition :to => :collecting, :do => :packages_state_to_collecting

      event :to_distribution do
        transition :collecting => :distributing
      end

      event :archive do
        transition :distributing => :archived
      end
    end

    has_many :packages, class_name: 'Distribution::Package', inverse_of: :package_list

    belongs_to :point, class_name: 'Distribution::Point', inverse_of: :package_lists

    attr_accessible :package_limit, :is_closed, :closed_by

    def closed?
      self.is_closed
    end

    def get_order_num
      self.packages.not_case.count + 1
    end

    private

    def check_package_limit
      self.package_limit = self.point.default_day_package_limit if self.package_limit.nil?
    end

    def packages_state_to_collecting
      self.packages.each {|package| package.start_collecting}
    end

  end
end
