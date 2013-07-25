module Distribution
  class PackageItem < ActiveRecord::Base

    before_create :get_info

    attr_accessible :item_id, :title, :organizer, :organizer_id, :is_next_time_pickup, :state_on_creation, :is_user_participate, :user_id

    validates_presence_of :item_id

    belongs_to :package

    scope :current_pickup, where(is_next_time_pickup: false)
    scope :next_time_pickup, where(is_next_time_pickup: true)
    scope :in_distribution, where{state.in ['accepted', 'issued']}

    state_machine :state, :initial => :pending do
      event :accept do
        transition :pending => :accepted
      end
      event :issue do
        transition :accepted => :issued
      end
    end

    include StateMachineScopes
    state_machine_scopes

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
