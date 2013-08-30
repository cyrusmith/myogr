module Distribution
  class ProcessorUtil
    def self.issue_package_items(items_ids)
      ActiveRecord::Base.transaction do
        users_ids = []
        packages = {}
        items_ids.each do |id|
          item = PackageItem.find(id)
          item.fire_events!(:issue)
          packages[item.package_id] = item.package unless packages.has_key?(item.package_id) or item.package.nil?
          item.package.fire_events!(:to_issued) if item.package and item.package.can_to_issued?
          users_ids << item.user_id unless users_ids.include? item.user_id
        end
        packages.each{|key, package| package.items.each do |item|
          unless item.issued?
            item.package = nil
            item.save
          end
        end
        }
        users_ids.each { |id| PackageItem.where(user_id: id).next_time_pickup.each { |item| item.update_attributes!(is_next_time_pickup: false) } }
      end
    end
  end
end