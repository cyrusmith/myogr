module Distribution
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia
    include Tenacity

    USER_CAN_CHANGE_STATES = [:accepted]
    ACTIVE_STATES = [:accepted, :collecting, :collected, :in_distribution_point, :in_delivery, :in_suitcase]

    scope :user_can_change, where(state: USER_CAN_CHANGE_STATES)
    scope :active, where(:state.in => ACTIVE_STATES)

    before_save :set_order

    field :order, type: Integer
    field :collector_id, type: Integer
    field :collection_date, type: Date
    field :comment, type: String

    embeds_many :items, class_name: 'Distribution::PackageItem'

    t_belongs_to :user
    belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages

    accepts_nested_attributes_for :items, allow_destroy: true

    attr_accessible :items_attributes, :comment, :collector_id, :collection_date

    state_machine :state, :initial => :accepted do
      event :start_collecting do
        transition :accepted => :collecting
      end
      event :finish_collecting do
        transition :collecting => :collected
      end
      event :to_distribution do
        transition :collected => :in_distribution_point
      end
      event :to_delivery do
        transition :collected => :in_delivery
      end
      event :to_suitcase do
        transition :collected => :in_suitcase
      end
      event :to_issued do
        transition :in_distribution_point => :issued, :in_delivery => :issued, :in_suitcase => :issued
      end
      event :utilize do
        transition :collected => :utilized, :in_distribution_point => :utilized
      end
    end

    def collect!(collector, collected_items)
      self.collector_id = collector
      self.items.each do |item|
        item.delete if !collected_items.index(item.item_id)
      end
      self.finish_collecting if self.can_finish_collecting?
    end

    private

    def set_order
      self.order = self.package_list.get_order_num
    end

    def finish_collecting
      self.collection_date = Date.today
      super
    end
  end
end
