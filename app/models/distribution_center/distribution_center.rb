module DistributionCenter
  class DistributionCenter
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    field :title, type: String
    field :head_user, type: Integer

    embeds_many :addresses
    has_many :package_lists
  end
end
