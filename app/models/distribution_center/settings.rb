module DistributionCenter
  class Settings < Settingslogic
    source "#{Rails.root}/config/distrib_center.yml"
    namespace Rails.env
  end
end
