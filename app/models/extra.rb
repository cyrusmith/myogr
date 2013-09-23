class Extra < Forum::Models
  self.table_name = 'ibf_member_extra'

  attr_accessible :id

  belongs_to :member, foreign_key: 'id'
end