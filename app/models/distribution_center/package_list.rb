module DistributionCenter
  class PackageList < ::Schedule
    include Mongoid::Document

    field :package_limit, type: Integer
    field :is_closed, type: Boolean, default: false
    field :closed_by, type: String

    belongs_to :distribution_center

    def closed?
      self.is_closed
    end

  end
end
