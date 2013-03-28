class Extra < ForumModels
  self.table_name = 'ibf_member_extra'

  belongs_to :member, foreign_key: 'id'
end