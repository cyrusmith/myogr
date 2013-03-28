module Admin
  module Salon
    class Settings < Settingslogic
      source "#{Rails.root}/config/salon.yml"
      namespace Rails.env
    end
  end
end