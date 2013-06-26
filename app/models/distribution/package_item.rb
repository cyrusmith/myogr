module Distribution
  class PackageItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    before_create :get_info

    field :item_id, type: Integer
    field :title, type: String
    field :organizer_id, type: Integer
    field :organizer, type: String
    #состояние закупки, в тот момент, когда пользователь отправил ее в сборку
    field :state_on_creation, type:String
    field :is_collected, type: Boolean, default: false
    field :is_user_participate, type: Boolean, default: true
    field :is_next_time_pickup, type: Boolean, default: false

    embedded_in :package

    scope :current_pickup, where(is_next_time_pickup: false)
    scope :next_time_pickup, where(is_next_time_pickup: true)

    validates_presence_of :item_id

    attr_accessible :item_id, :title, :organizer, :organizer_id, :is_next_time_pickup, :state_on_creation, :is_user_participate

    def next_time_pickup?
      self.is_next_time_pickup
    end

    def set_next_time_pickup
      self.is_next_time_pickup = true
    end

    def collected
      self.is_collected=true
    end

    private

    def get_info
      distributor = Distributor.find self.item_id
      self.title = distributor.title
      self.organizer = distributor.organizer
    end

  end
end
