module Distribution
  class PluginsController < ApplicationController
    def reception_logger
      respond_to do |format|
        format.js
      end
    end
  end
end
