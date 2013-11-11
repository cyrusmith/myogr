# coding: utf-8
module Distribution
  class PackageList < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    acts_as_schedule_extension
    paginates_per 50
    delegate :day_off?, to: :schedule

    before_save :set_package_limit, if: Proc.new { |list| list.package_limit.nil? }

    attr_accessible :date, :is_day_off, :from, :till, :package_limit, :is_closed, :closed_by

    has_many :packages, class_name: 'Distribution::Package'
    belongs_to :point, class_name: 'Distribution::Point'

    accepts_nested_attributes_for :packages

    state_machine :state, :initial => :forming do
      store_audit_trail
      event :to_collecting do
        transition :forming => :collecting
      end
      after_transition :to => :collecting do |package_list|
        package_list.fire_event_for_linked_packages(:start_collecting)
      end

      event :to_distribution do
        transition :collecting => :distributing
      end
      after_transition :to => :distributing do |package_list|
        package_list.fire_event_for_linked_packages(:finish_collecting)
        package_list.fire_event_for_linked_packages(:to_distribution)
      end

      event :archive do
        transition :distributing => :archived
      end
      #TODO удалить. Автоматом закрывать ведомость если все заказы выданы.
      after_transition :to => :archived do |package_list|
        package_list.fire_event_for_linked_packages(:to_issued)
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

    include StateMachineScopes
    state_machine_scopes

    def human_date
      Russian::strftime self.date, '%d.%m.%Y'
    end

    def order_number_for(method)
      packages = self.packages
      max_order = packages.where(distribution_method: method.to_s).maximum(:order) unless packages.empty?
      max_order ? max_order + 1 : 1
    end

    def fire_event_for_linked_packages(event_name)
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
        [true, '', "Записано #{count_limited_packages} из #{self.package_limit}. Кейсов #{self.packages.case.count}"]
      end
      info[0] = true if admin_access
      info
    end

    def limit_filled?
      count_limited_packages >= self.package_limit
    end

    private

    def set_package_limit
      self.package_limit = self.point.default_day_package_limit
    end

    def count_limited_packages
      self.packages.not_case.where{state != 'canceled'}.count
    end

  end
end
