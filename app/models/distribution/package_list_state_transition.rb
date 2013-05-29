module Distribution
  class PackageListStateTransition
    include Mongoid::Document
    field :event, type: String
    field :from, type: String
    field :to, type: String
    field :created_at, type: Time
    embedded_in :package_list
  end
end