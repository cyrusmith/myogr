# encoding: utf-8
class PackingLists < Prawn::Document
  delegate :params, :h, :raw, :t, :number_to_currency, :point, to: :@view
  Widths = [30, 60, 270, 80, 100]
  Headers = %w(№ Закупка Наименование Организатор Примечание)
  @@num = 1

  def initialize(package_list, view)
    super(margin: [10])
    @package_list = package_list
    @view = view
    @@num = 1
  end

  def to_pdf
    Distribution::Package::METHODS.each do |method_name|
      @package_list.packages.distribution_method(method_name).sort { |a, b| a.order.to_i <=> b.order.to_i }.each do |package|
        pa package
      end
    end
    creation_date = Time.zone.now.strftime("Лист сгенерирован %e %b %Y %H:%M")
    go_to_page(page_count)
    bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
      text creation_date, :align => :right, :style => :italic, :size => 6
    }
    render
  end

  def new_row(num, item_id, title, organizer_name, comment)
    row = [num, item_id, CGI.unescapeHTML(title)[0..49], CGI.unescapeHTML(organizer_name), comment]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2, :size => 9
    end
  end

  def pa(list)
    num = 1
    font_families.update(
        'Verdana' => {
            :bold => "#{Rails.root}/public/assets/font/verdanab.ttf",
            :italic => "#{Rails.root}/public/assets/font/verdanai.ttf",
            :normal => "#{Rails.root}/public/assets/font/verdana.ttf"
        }
    )
    font 'Verdana', :size => 10

    formatted_package_date = Russian::strftime list.package_list.date, '%d.%m.%y'
    table([[list.code.to_s, "Упаковочный лист №#{list.code} / #{formatted_package_date}"]], :column_widths => [80, 460]) do
      columns(0).size = 18
      columns(0).borders = [:top, :right, :left, :bottom]
      columns(1).size = 14
      columns(1).borders = []
      cells.font_style = :bold
      cells.align = :center
      cells.valign = :center
    end
    #text , :size => 14, :style => :bold, :align => :center
    data = [
        ["Пользователь: #{list.user.try(:display_name)}", "Место получения: #{list.package_list.point.address.full_address}"],
        ["Паспорт получателя: #{list.document_number}", "Дата получения: #{formatted_package_date} - #{Russian::strftime list.package_list.date + 2.days, '%d.%m.%y'}",]

    ]
    table(data, :column_widths => [270, 270]) do
      cells.borders = []
      cells.padding = 3
    end

    data = []
    list.items.each do |item|
      data << new_row(num, item.item_id, item.title, item.organizer, '')
      num = num + 1
    end

    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map { |d| [d] })], :header => true, :row_colors => %w[ffffff]) do
      row(0).style :background_color => 'cccccc'
    end
    move_down 8
    data = [['Подпись сборщика', '', '', 'Подпись получателя', '']]
    table(data, :column_widths => [110, 100, 40, 120, 100]) do
      cells.borders = []
      row(0).columns([1, 4]).borders = [:bottom]
    end
    table([['Дата сборки', '', '', 'Дата получения', '']], :column_widths => [80, 100, 70, 100, 100]) do
      cells.borders = []
      row(0).columns([1, 4]).borders = [:bottom]
    end
    move_down 20
    dash 10
    horizontal_rule
    move_down 20
  end

end