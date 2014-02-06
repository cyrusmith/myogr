# encoding: utf-8
# Ведомость приемки товара
class ReceptionSummary < CommonDocument

  def initialize(point, group_number, view, options={})
    @point = point
    @group_number = group_number
    @package_items = Distribution::PackageItem.where(receiving_group_number: group_number)
    options[:numerate_pages] = true
    super(view, options)
  end

  def output
    first_item = @package_items.first
    acceptance_date = first_item.audits.where(to: 'accepted').order('created_at DESC').first.created_at.to_date
    text "Приходная ведомость №#{@group_number} от #{I18n.l acceptance_date}", :size => 12, :style => :bold
    move_down 5
    text @point.location.full_address, size: 8
    move_down 5
    stroke_horizontal_rule
    move_down 5
    y_position = cursor
    block_width = bounds.width/2
    text_box "Приемщик: #{first_item.receiver}", at:[0, y_position], width: block_width
    text_box "Принято от: #{first_item.recieved_from}", at:[block_width, y_position], width: block_width
    move_down 20
    text "Отправления от #{first_item.organizer_id}/#{first_item.organizer} :"
    headers = ['Получатель', 'Наименование', 'Код', 'Служебные отметки']
    column_widths = [150, 180, 110, 100]
    data = []
    data << make_table([headers], column_widths: column_widths) do |t|
      t.row(0).style align: :center,
                     valign: :center,
                     font_style: :bold,
                     background_color: 'cccccc'
    end

    @package_items.each do |item|
      username = item.user.nil? ? '' : "#{item.user.id}/#{item.user.display_name}"
      title = "#{item.item_id}/#{CGI.unescapeHTML(item.title)}"
      data << make_table([[username, title, item.barcode.barcode_string(true), set_marks(item)]], column_widths: column_widths) do |t|
        t.cells.style :borders => [:left, :right], :padding => [2, 5], single_line: true
        t.columns(2).align = :right
        t.columns(3).single_line = false
      end
    end

    table([*(data.map { |d| [d] })], :header => true)
    move_down 8

    text "Принято #{@package_items.count} #{Russian.p(@package_items.count, 'позиция', 'позиции', 'позиций')} для #{@package_items.uniq{|i| i.user_id}.count} пользоватей"
    move_down 8
    if first_item.not_conform_rules.present?
      special_marks =  first_item.not_conform_rules.map { |subject| I18n::t('distribution.item.not_conform_rules.' + subject.to_s) }.join('. ')
      text "Прочие отметки: #{special_marks}"
      move_down 8
    end

    table([['Подпись приемщика', '', '', 'Подпись отправителя', '']], :column_widths => [120, 130, 40, 140, 100]) do
      cells.borders = []
      cells.padding = 0
      row(0).columns([1, 4]).borders = [:bottom]
    end
  end

  private

  def set_marks(item)
    result = []
    result << 'кейс' if item.user.case_active?
    result << 'сегодня' if (!item.package.nil? && item.package.package_list.date.eql?(Date.today) && !item.package.completed?)
    result << 'завтра' if (!item.package.nil? && item.package.package_list.date.eql?(Date.tomorrow))
    result.join ', '
  end

end