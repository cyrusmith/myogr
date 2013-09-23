module Distribution
  class ProcessorUtil
    def self.issue_package_items(packages_ids, items_ids)
      items_ids = items_ids || Array.new
      packages_ids = packages_ids || Array.new
      ActiveRecord::Base.transaction do
        users_ids = []
        # issue items
        items_ids.each do |id|
          item = PackageItem.find(id)
          item.is_next_time_pickup = false
          item.fire_events!(:issue)
          users_ids << item.user_id unless users_ids.include? item.user_id
        end
        # issue_packdages
        packages_ids.each do |id|
          package = Package.find(id) || Package.new
          package.fire_events!(:to_issued) if package.can_to_issued?
          package.items.each do |item|
            unless item.issued?
              item.package = nil
              item.save!
            end
          end
        end
        # reset_next_time_pickup
        users_ids.each { |id| PackageItem.where(user_id: id).next_time_pickup.each { |item| item.update_attributes!(is_next_time_pickup: false) } }
      end
    end
  end
end