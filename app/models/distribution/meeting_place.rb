module Distribution
  class MeetingPlace < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    attr_accessible :description, :location_attributes

    delegate :short_address, :full_address, to: :location

    has_one :location, as: :addressable, dependent: :destroy
    has_many :appointments
    has_many :package_lists, through: :appointments

    accepts_nested_attributes_for :location

  end
end
