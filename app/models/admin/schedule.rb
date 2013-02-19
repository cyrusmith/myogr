module Admin
  class Schedule
    include Mongoid::Document
    field :date, type: Date
    field :working_from, type: Time
    field :working_till, type: Time
  end
end