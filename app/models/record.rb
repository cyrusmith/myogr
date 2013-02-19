class Record
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :user, type: Array
  field :datetime, type: Time
  field :procedures, type: Array
  field :employee, type: Array
end
