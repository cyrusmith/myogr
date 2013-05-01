module Distribution
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia
    include Tenacity

    field :order, type: Integer
    field :collector_id, type: Integer
    field :collection_date, type: Date
    #TODO Добавить связь со сборщиком и дату сборки

    embeds_many :items, class_name: 'Distribution::PackageItem'

    t_belongs_to :user
    belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages

    accepts_nested_attributes_for :items, allow_destroy: true

    attr_accessible :items_attributes

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
        transition :collected => :utilized
      end
    end

    def collect!(collector, collected_items)
      self.collector_id = collector
      self.items.each do |item|
        item.delete if !collected_items.index(item.item_id)
      end
      self.finish_collecting if self.can_finish_collecting?
    end

    def finish_collecting
      self.collection_date = Date.today
      super
    end
  end
end
