# encoding: utf-8
columns_widths = [40, 50, 270, 80, 100]
headers = %w(№ Закупка Наименование Организатор Примечание)

@package_list.packages.each do |package|
  font_families.update(
      'Verdana' => {
          :bold => '/home/nlopin/prawn-fonts/verdanab.ttf',
          :italic => '/home/nlopin/prawn-fonts/verdanai.ttf',
          :normal => '/home/nlopin/prawn-fonts/verdana.ttf'})
  font 'Verdana', :size => 10
  formatted_package_date = Russian::strftime @package_list.date, '%d.%m.%y'
  text "Упаковочный лист №#{package.order}. Ведомость #{formatted_package_date}", :size => 15, :style => :bold, :align => :center
  move_down 18
  text "Пользователь: #{package.user.try(:display_name)}"
  move_down 4
  text "Дата получения: #{formatted_package_date} - #{Russian::strftime @package_list.date + 2.days, '%d.%m.%y'}"
  move_down 4
  text "Место получения: #{@package_list.point.address.full_address}"
  move_down 4
  text "Паспорт получателя: XXXX XXXXXX"
  move_down 10

  data = []
  i = 1
  package.items.each do |item|
    row = [i, item.item_id, item.title, User.find(item.organizer).display_name, '']
    data << make_table([row]) do |t|
      t.column_widths = columns_widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
    i = i + 1
  end

  head = make_table([headers], :column_widths => columns_widths)
  table([[head], *(data.map { |d| [d] })], :header => true, :row_colors => %w[ffffff]) do
    row(0).style :background_color => 'cccccc'
  end

  creation_date = Time.zone.now.strftime("Лист сгенерирован %e %b %Y %H:%M")
  go_to_page(page_count)
  bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
    text creation_date, :align => :right, :style => :italic, :size => 6
  }
end