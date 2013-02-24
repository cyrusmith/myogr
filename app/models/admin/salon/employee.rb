module Admin
  module Salon
    class Employee
      include Mongoid::Document
      field :first_name, type: String
      field :last_name, type: String
      field :position, type: String
      field :specialization, type: String
    end
  end
end
