# coding: utf-8
module Distribution
  class PackageList < ActiveRecord::Base
    paginates_per 50

    delegate :date, :date=, :day_off?,  :is_day_off, :is_day_off=, :from, :from=, :till, :till=, to: :schedule

    before_save :set_package_limit, if: Proc.new { |list| list.package_limit.nil? }

    state_machine :state, :initial => :forming do
      store_audit_trail
      event :to_collecting do
        transition :forming => :collecting
      end
      #TODO тут кроется потенциальный глюк, так как транзакций в монго нет, а операции атомарны только в рамках одного объекта.
      after_transition :to => :collecting do |package_list|
        package_list.packages_fire_event(:start_collecting)
      end

      event :to_distribution do
        transition :collecting => :distributing
      end
      after_transition :to => :distributing do |package_list|
        package_list.packages_fire_event(:finish_collecting)
        package_list.packages_fire_event(:to_distribution)
      end

      event :archive do
        transition :distributing => :archived
      end
      after_transition :to => :archived do |package_list|
        package_list.packages_fire_event(:to_issued)
      end

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

    state_machine.states.map do |state|
      scope state.name, where(:state => state.name.to_s)
    end

    has_one :schedule, as: :extension, dependent: :destroy
    has_many :packages, class_name: 'Distribution::Package', inverse_of: :package_list

    belongs_to :point, class_name: 'Distribution::Point', inverse_of: :package_lists

    #embeds_many :package_list_state_transitions, class_name: 'Distribution::PackageListStateTransition'

    attr_accessible :package_limit, :is_closed, :closed_by
    accepts_nested_attributes_for :packages

    def human_date
      Russian::strftime self.date, '%d.%m.%Y'
    end

    def order_number_for(method)
      packages = self.packages
      max_order = packages.try(where(distribution_method: method).max(:order)) unless packages.empty?
      max_order ? max_order + 1 : 1
    end

    def packages_fire_event(event_name)
      event_name = event_name.to_sym
      self.packages.each { |package| package.fire_state_event(event_name) } if Package.new.state_paths.events.include? event_name
    end

    def get_info(is_filled_selectable=false, admin_access = false)
      info = if day_off?
        [false, 'day-off', 'Нерабочий день']
      elsif closed?
        [false, 'closed', 'Запись закрыта']
      elsif limit_filled? and !is_filled_selectable
        [false, 'limit-filled', 'Лимит записей исчерпан']
      else
        [true, '', "Записано #{self.packages.not_case.count} из #{self.package_limit}. Кейсов #{self.packages.case.count}"]
      end
      info[0] = true if admin_access
      info
    end

    def limit_filled?
      self.packages.not_case.count >= self.package_limit
    end

    private

    def set_package_limit
      self.package_limit = self.point.default_day_package_limit
    end

  end
end
