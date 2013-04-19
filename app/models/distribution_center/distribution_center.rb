module DistributionCenter
  class DistributionCenter
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    store_in collection: 'distribution_centers'

    before_save :check_head_permission

    field :title, type: String
    field :head_user, type: Integer
    field :comment, type: String

    embeds_one :address
    has_many :distribution_center_package_lists, :class_name => 'DistributionCenter::PackageList'

    attr_accessible :title, :head_user, :comment

    def head_name
      User.find(self.head_user).try :display_name
    end

    def head_name=(name)
      self.head_user=User.find_by_display_name(name).id if name.present?
    end

    accepts_nested_attributes_for :address,
                                  reject_if: lambda { |a| a[:title].blank? and a[:head_user].blank? }


    private

    def check_head_permission
      user = User.find(self.head_user)
      user.add_role UserRole::DISTRIB_CENTER_MANAGER unless user.has_role? UserRole::DISTRIB_CENTER_MANAGER
    end

  end
end
