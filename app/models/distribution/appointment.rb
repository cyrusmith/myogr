module Distribution
  class Appointment < ActiveRecord::Base
    self.table_name_prefix = 'distribution_'

    attr_accessible :from, :till, :meeting_place_id

    delegate :short_address, to: :meeting_place

    belongs_to :package_list
    belongs_to :meeting_place
  end
end
