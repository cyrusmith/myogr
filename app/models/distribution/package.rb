# encoding: utf-8
module Distribution
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia
    include Tenacity

    ACTIVE_STATES = [:accepted, :collecting, :collected, :in_distribution]
    FINAL_STATES = [:issued, :utilized]
    METHODS = [:at_point, :case, :delivery]
    #TODO в настройки
    METHODS_IDENTIFICATOR = {at_point: '', case: 'К', delivery: 'Д'}

    scope :active, where(:state.in => ACTIVE_STATES)
    scope :case, where(:distribution_method => :case)
    scope :not_case, where(:distribution_method.nin => [:case])
    scope :distribution_method, ->(method_name) { where(:distribution_method => method_name) }
    #scope :not_case, self.not.where(:distribution_method => :case)

    before_create :set_order

    field :order, type: Integer
    field :code, type: String
    field :distribution_method, type: Symbol, default: :at_point
    field :collector_id, type: Integer
    field :collection_date, type: Date
    field :document_number, type: String
    validates :document_number, presence: true, length: {minimum: 5, maximum: 12}

    embeds_many :items, class_name: 'Distribution::PackageItem'
    embeds_many :package_state_transitions, class_name: 'Distribution::PackageStateTransition'

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

    include StateMachineScopes
    state_machine_scopes :state

    def collect!(collector, collected_items)
      self.collector_id = collector
      self.items.each do |item|
        item.delete if !collected_items.index(item.item_id)
      end
      #TODO уточнить, нужно ли хранить дату последнего или всех обновлений заказов
      self.finish_collecting if self.can_finish_collecting?
    end

    def set_order
      order_num = self.package_list.order_number_for(self.distribution_method)
      self.order = order_num
      self.code = order_num.to_s + METHODS_IDENTIFICATOR[self.distribution_method]
    end

  end
end
