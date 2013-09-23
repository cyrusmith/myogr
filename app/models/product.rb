class Product < Forum::Models
  self.table_name = 'ibf_zakup_products'

  attr_readonly :tid, :name, :big_img, :small_img, :short_desc
end