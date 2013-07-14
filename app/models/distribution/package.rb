# encoding: utf-8
module Distribution
  class Package < ActiveRecord::Base
    include Tenacity

    ACTIVE_STATES = [:accepted, :collecting, :collected, :in_distribution]
    FINAL_STATES = [:issued.to_s, :utilized.to_s]
    METHODS = [:at_point, :case, :delivery]
    #TODO в настройки
    METHODS_IDENTIFICATOR = {at_point: '', case: 'К', delivery: 'Д'}

    scope :in_states, lambda {|states_array| where{state.in states_array.map{|v| v.to_s}} }
    scope :active, where(state: ACTIVE_STATES.map{|state| state.to_s})
    scope :case, where(distribution_method: 'case')
    scope :not_case, where{distribution_method.not_eq 'case'}
    scope :distribution_method, ->(method_name) { where(distribution_method: method_name.to_s) }
    #scope :not_case, self.not.where(:distribution_method => :case)

    before_create :set_order

    validates :document_number, presence: true, length: {minimum: 5, maximum: 12}

    has_many :items, class_name: 'Distribution::PackageItem'

    t_belongs_to :user
    belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages

    accepts_nested_attributes_for :items, allow_destroy: true

    attr_accessible :items_attributes, :collector_id, :collection_date, :distribution_method, :document_number

    state_machine :state, :initial => :accepted do
      store_audit_trail
      event :start_collecting do
        transition :accepted => :collecting
      end

      before_transition :on => :finish_collecting do |package|
        package.collection_date = Time.now
      end
      event :finish_collecting do
        transition :collecting => :collected
      end
      event :to_distribution do
        transition :collected => :in_distribution
      end
      event :to_issued do
        transition [:collected, :in_distribution] => :issued
      end
      event :utilize do
        transition [:collected, :in_distribution] => :utilized
      end

      state :accepted do
        def changeable?
          true
        end
      end

      state all - :accepted do
        def changeable?
          false
        end
      end
    end

    state_machine.states.map do |state|
      scope state.name, where(:state => state.name.to_s)
    end

    include StateMachineScopes
    state_machine_scopes :state

    def active?
      ACTIVE_STATES.include? self.state.to_sym
    end

    def collect!(collector, collected_items)
      self.collector_id = collector
      self.items.each do |item|
        item.collected if !collected_items.include?(item.item_id)
      end
      #TODO уточнить, нужно ли хранить дату последнего или всех обновлений заказов
      self.finish_collecting if self.can_finish_collecting?
    end

    def set_order
      order_num = self.package_list.order_number_for(self.distribution_method)
      self.order = order_num
      self.code = order_num.to_s + METHODS_IDENTIFICATOR[self.distribution_method.to_sym]
    end

  end
end
