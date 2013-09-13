# encoding: utf-8
class ReceptionSummary < CommonDocument

  def initialize(point, package_items, view, options={})
    super(view, options)
    @point = point
    @package_items = package_items
  end

  def output
    text "Приходная ведомость от #{Date.today}", :size => 12, :style => :bold
    move_down 5
    text "Центр раздач: #{@point.address.full_address}"
    horizontal_rule
    text "Принято от: #{@package_items.first.recieved_from}"
    move_down 5
    text "Отправления:"
    headers = ['Отправитель', 'Наименование', 'Код', 'Получатель', 'Упак. не соотв. правилам', 'Маркировка не соотв. правилам', 'Служебные отметки']
    head = make_table([headers], :column_widths => [90, 140, 100, 90, 40, 40, 40]) do |t|
      t.row(0).align = :center
      t.row(0).valign = :center
      t.row(0).font_style = :bold
    end
    data = []
    @package_items.each do |item|
      username = item.user.nil? ? '' : "#{item.user.id}/#{item.user.display_name}"
      sender = "#{item.organizer_id}/#{item.organizer}"
      data << make_table([[sender, CGI.unescapeHTML(item.title), item.barcode.barcode_string(true), username, '', '', set_marks(item)]]) do |t|
        t.column_widths = [90, 140, 100, 90, 40, 40, 40]
        t.columns(2).align = :right
        t.cells.style :borders => [:left, :right], :padding => [2, 5]
      end
    end
    table([[head], *(data.map { |d| [d] })], :header => true, :row_colors => %w[ffffff]) do
      row(0).style :background_color => 'cccccc'
    end
    move_down 8
    data = [['Приемщик', '', '', 'Подпись отправителя', '']]
    table(data, :column_widths => [100, 150, 40, 140, 100]) do
      cells.borders = []
      row(0).columns([1, 4]).borders = [:bottom]
    end
  end

  private

  def set_marks(item)
    result = []
    result << 'Кейс' if item.user.case?
    result << 'Запись сегодня' if (!item.package.nil? && item.package.package_list.date.eql?(Date.today) && !item.package.completed?)
    result << 'Запись завтра' if (!item.package.nil? && item.package.package_list.date.eql?(Date.tomorrow))
    result.join ','
  end

end