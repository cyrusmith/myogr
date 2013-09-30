#encoding: utf-8
class CollectionTags < CommonDocument

  def initialize(package_list, view, options={})
    super(view, page_size: [170, 113], margin: 5, page_layout: :landscape)
    @package_list = package_list
  end

  protected
  def output
    @package_list.packages.sort{|x,y| x.order <=> y.order}.each do |package|

      move_cursor_to bounds.top/2 + 20
      text package.code, align: :center, size: 40, style: :bold

      move_cursor_to bounds.top
      text User.find(package.user_id).display_name, size: 14

      move_cursor_to bounds.bottom+25
      text Russian::strftime(@package_list.date, '%d.%m.%y'), align: :center, size: 20
      start_new_page
    end
  end


end