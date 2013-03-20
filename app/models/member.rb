class Member < ForumModels
  self.table_name = 'ibf_members'
  has_one :credential, foreign_key: 'converge_id', readonly: true
  has_one :extra, foreign_key: 'id'

  attr_accessible :name, :email, :phone

  def length=(minutes)
    write_attribute(:length, minutes.to_i * 60)
  end

  def length
    read_attribute(:length) / 60
  end

end