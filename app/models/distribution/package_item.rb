module Distribution
  class PackageItem < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    before_create :get_info

    attr_accessible :item_id, :title, :organizer, :organizer_id, :is_next_time_pickup, :state_on_creation, :is_user_participate, :location, :user_id, :barcode, :receiving_group_number, :receiver, :not_conform_rules

    validates_presence_of :item_id

    has_one :barcode, :class_name => 'Distribution::Barcode', inverse_of: :package_item
    has_many :audits, :class_name => 'Distribution::PackageItemStateTransition'
    belongs_to :user
    belongs_to :org, foreign_key: :organizer_id, class_name: 'User'
    belongs_to :package

    NOT_CONFORM_HASH = {packaging: 1, marking: 2}

    scope :current_pickup, where(is_next_time_pickup: false)
    scope :next_time_pickup, where(is_next_time_pickup: true)
    scope :in_distribution, where{state.in %w(accepted issued)}

    state_machine :state, :initial => :pending do
      store_audit_trail
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

    def collected
      self.is_collected=true
    end

    def reception_date
      self.audits.where(to: 'accepted').order('created_at DESC').first.created_at.to_date
    end


    def self.create_batch!(array_of_params)
      self.transaction do
        array_of_params.each do |params|
          raise BarcodeAlreadyBelongsToPackageError.new(params[:barcode]) if (params.has_key? :barcode) && (params[:barcode].package_item.present?)
          PackageItem.create!(params)
        end
      end
      true
    end

    # Номер следующей ведомости приемки
    def self.get_next_group_number
      (self.maximum(:receiving_group_number) || 0) + 1
    end

    private

    def get_info
      distributor = Distributor.find self.item_id
      self.title = distributor.title
      self.organizer = distributor.organizer
    end

  end
end
