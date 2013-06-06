module Distribution
  class PackageList < ::Schedule
    include Mongoid::Document
    paginates_per 50

    before_save :check_package_limit

    field :package_limit, type: Integer
    field :closed_by, type: String

    state_machine :state, :initial => :forming do
      store_audit_trail
      event :to_collecting do
        transition :forming => :collecting
      end
      #TODO тут кроется потенциальный глюк, так как транзакций в монго нет, а операции атомарны только в рамках одного объекта.
      after_transition :to => :collecting, :do => :packages_state_to_collecting

      event :to_distribution do
        transition :collecting => :distributing
      end
      after_transition :to => :distributing, :do => :packages_state_to_distribution

      event :archive do
        transition :distributing => :archived
      end
      after_transition :to => :archived, :do => :packages_state_to_issued

      state :forming do
        def closed?
          false
        end
      end

      state all - :forming do
        def closed?
          true
        end
      end
    end

    has_many :packages, class_name: 'Distribution::Package', inverse_of: :package_list

    belongs_to :point, class_name: 'Distribution::Point', inverse_of: :package_lists

    embeds_many :package_list_state_transitions, class_name: 'Distribution::PackageListStateTransition'

    attr_accessible :package_limit, :is_closed, :closed_by

    def order_number_for(method)
      self.packages.where(distribution_method: method).count + 1
    end

    private

    def check_package_limit
      self.package_limit = self.point.default_day_package_limit if self.package_limit.nil?
    end

    def packages_state_to_collecting
      self.packages.each {|package| package.start_collecting}
    end

    def packages_state_to_distribution
      self.packages.each {|package| package.to_distribution}
    end

    def packages_state_to_issued
      self.packages.each {|package| package.to_issued}
    end

  end
end
