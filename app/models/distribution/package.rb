module Distribution
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia
    include Tenacity

    before_save :set_order

    field :order, type: Integer
    field :comment, type: String
    #TODO Добавить связь со сборщиком и дату сборки

    embeds_many :items, class_name: 'Distribution::PackageItem'

    t_belongs_to :user
    belongs_to :package_list, class_name: 'Distribution::PackageList', inverse_of: :packages

    accepts_nested_attributes_for :items, allow_destroy: true

    attr_accessible :items_attributes, :order

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

    private

    def set_order
      self.order = self.package_list.get_order_num
    end

  end
end
