# Маркировочные листы
class ReceptionLists < CommonDocument
  def initialize(group_number, view, options={})
    @package_topics = Distribution::PackageItem.where(receiving_group_number: group_number).group(:item_id)
    super(view, page_size: 'A5', page_layout: :landscape)
  end

  def output
    i = 0
    @package_topics.each do |topic|
      text topic.organizer, size: 60, style: :bold
      stroke_horizontal_rule
      move_down 10
      acceptance_date = topic.audits.where(to: 'accepted').order('created_at DESC').first.created_at.to_date
      text I18n::l(acceptance_date), size: 40

      move_down 20
      text topic.title, size: 30

      i = i + 1
      start_new_page unless i == @package_topics.size
    end
  end


end