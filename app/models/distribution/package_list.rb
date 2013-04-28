module Distribution
  class PackageList < ::Schedule
    include Mongoid::Document

    field :package_limit, type: Integer
    field :is_closed, type: Boolean, default: false
    field :closed_by, type: String

    state_machine :state, :initial => :forming do
      event :to_collecting do
        transition :forming => :collecting
      end
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

  end
end
