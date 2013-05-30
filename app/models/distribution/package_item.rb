module Distribution
  class PackageItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    before_create :get_info

    field :item_id, type: Integer
    field :title, type: String
    field :organizer, type: Integer
    #состояние закупки, в тот момент, когда пользователь отправил ее в сборку
    field :state_on_creation, type:String
    field :is_user_participate, type: Boolean, default: true
    field :is_next_time_pickup, type: Boolean, default: false

    embedded_in :package

    scope :current_pickup, where(is_next_time_pickup: false)
    scope :next_time_pickup, where(is_next_time_pickup: true)

    validates_presence_of :item_id

    attr_accessible :item_id, :title, :organizer, :is_next_time_pickup, :state_on_creation

    def next_time_pickup?
      self.next_time_pickup
    end

    private

    def get_info
      distributor = Distributor.find self.item_id
      self.title = distributor.title
      self.organizer = distributor.starter_id
    end

  end
end
