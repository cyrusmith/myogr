module Forum
  class Models < ActiveRecord::Base
    establish_connection :ogromno
    self.abstract_class = true
  end
end