module Admin
  module Salon
    class Procedure
      include Mongoid::Document
      field :name, type: String
      field :duration, type: Float
      field :price, type: Integer
      field :comment, type: String
      field :group, type: String

      #monetize :price_cents, :numericality => { :greater_than => 0, :only_integer => true}

      @@possible_groups = [['nails'], ['barbery'], ['massage'], ['cosmetology']]

      def self.possible_groups
        @@possible_groups
      end
    end
  end
end
