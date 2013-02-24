class Record
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :employee

  field :user, type: String
  field :record_date, type: Date
  field :record_time, type: Time
  field :procedures, type: Array
  field :employee, type: String
end
