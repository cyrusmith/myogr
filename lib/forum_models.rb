class ForumModels < ActiveRecord::Base
  establish_connection :ogromno
  self.abstract_class = true
  #def self.table_name_prefix
  #  'ibf_'
  #end

end