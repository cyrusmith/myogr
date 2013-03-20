class Credential < ForumModels
  self.table_name = 'ibf_members_converge'

  belongs_to :member, foreign_key: 'id'
end