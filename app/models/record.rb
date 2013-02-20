class Record
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :user, type: String
  field :record_date, type: Date
  field :record_time, type: Time
  field :procedures, type: Array
  field :employee, type: String
end
