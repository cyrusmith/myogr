# encoding: utf-8
class PackingLists < Prawn::Document
  delegate :params, :h, :raw, :t, :number_to_currency, :point, to: :@view
  Widths = [30, 60, 270, 80, 100]
  Headers = %w(№ Закупка Наименование Организатор Примечание)
  @@num = 1

  def initialize(package_list, view)
    super()
    @package_list = package_list
    @view = view
    @@num = 1
  end

  def to_pdf
    @package_list.packages.sort{|a,b| a.order <=> b.order}.each do |package|
      pa package
    end
    creation_date = Time.zone.now.strftime("Лист сгенерирован %e %b %Y %H:%M")
    go_to_page(page_count)
    bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
      text creation_date, :align => :right, :style => :italic, :size => 6
    }
    render
  end

  def new_row(item_id, title, organizer_name, comment)
    row = [@@num, item_id, h(title), h(organizer_name), comment]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end

  def pa(list)
    font_families.update(
        'Verdana' => {
            :bold => "#{Rails.root}/public/assets/font/verdanab.ttf",
            :italic => "#{Rails.root}/public/assets/font/verdanai.ttf",
            :normal => "#{Rails.root}/public/assets/font/verdana.ttf"
        }
    )
    font 'Verdana', :size => 10
    formatted_package_date = Russian::strftime list.package_list.date, '%d.%m.%y'
    text "Упаковочный лист №#{list.order}. Ведомость #{formatted_package_date}", :size => 15, :style => :bold, :align => :center
    move_down 18
    text "Пользователь: #{list.user.try(:display_name)}"
    move_down 4
    text "Дата получения: #{formatted_package_date} - #{Russian::strftime list.package_list.date + 2.days, '%d.%m.%y'}"
    move_down 4
    text "Место получения: #{list.package_list.point.address.full_address}"
    move_down 4
    text "Паспорт получателя: #{list.document_number}"
    move_down 10

    data = []
    list.items.each do |item|
      data << new_row(item.item_id, item.title, User.find(item.organizer).try(:display_name), '')
      @@num = @@num + 1
    end

    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[ffffff]) do
      row(0).style :background_color => 'cccccc'
    end
    move_down 10
    data = [['Подпись сборщика', '', '', 'Подпись получателя','']]
    table(data, :column_widths => [110, 100, 40, 120, 100 ]) do
      cells.borders = []
      row(0).columns([1,4]).borders = [:bottom]
    end
    table([['Дата сборки', '', '', 'Дата получения', '']], :column_widths => [80, 100, 70, 100, 100 ]) do
      cells.borders = []
      row(0).columns([1,4]).borders = [:bottom]
    end
    move_down 10
  end

end