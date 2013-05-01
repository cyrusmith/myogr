module Distribution
  class PackageItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    after_initialize :get_info

    field :item_id, type: Integer
    field :title, type: String
    field :organizer, type: Integer

    embedded_in :package

    validates_presence_of :item_id

    attr_accessible :item_id

    private

    def get_info
      distributor = Distributor.find self.item_id
      self.title = distributor.title
      self.organizer = distributor.starter_id
    end

  end
end
