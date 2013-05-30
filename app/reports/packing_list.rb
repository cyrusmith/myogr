# encoding: utf-8
class PackingList < Prawn::Document
  delegate :params, :h, :raw, :link_to, :number_to_currency, :point, to: :@view
  Widths = [40, 50, 270, 80, 100]
  Headers = %w(№ Закупка Наименование Организатор Примечание)
  @@num = 1

  def initialize(package, view)
    super()
    @package_list = package
    @view = view
    @@num = 1
  end

  def new_row(item_id, title, organizer_name, comment)
    row = [@@num, item_id, h(title), h(organizer_name), comment]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end

  def to_pdf
    initFonts
    formatted_package_date = Russian::strftime @package_list.package_list.date, '%d.%m.%y'
    text "Упаковочный лист №#{@package_list.order}. Ведомость #{formatted_package_date}", :size => 15, :style => :bold, :align => :center
    move_down 18
    text "Пользователь: #{@package_list.user.try(:display_name)}"
    move_down 4
    text "Дата получения: #{formatted_package_date} - #{Russian::strftime @package_list.package_list.date + 2.days, '%d.%m.%y'}"
    move_down 4
    text "Место получения: #{@package_list.package_list.point.address.full_address}"
    move_down 4
    text "Паспорт получателя: XXXX XXXXXX"
    move_down 10

    data = []
    @package_list.items.each do |item|
      data << new_row(item.item_id, item.title, User.find(item.organizer).try(:display_name), '')
      @@num = @@num + 1
    end

    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[ffffff]) do
      row(0).style :background_color => 'cccccc'
    end

    create_footer_timestamp
    render
  end

  def create_footer_timestamp
    creation_date = Time.zone.now.strftime("Лист сгенерирован %e %b %Y %H:%M")
    go_to_page(page_count)
    bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
      text creation_date, :align => :right, :style => :italic, :size => 6
    }
  end

  def initFonts
    font_families.update(
        'Verdana' => {
            :bold => '/home/nlopin/prawn-fonts/verdanab.ttf',
            :italic => '/home/nlopin/prawn-fonts/verdanai.ttf',
            :normal => '/home/nlopin/prawn-fonts/verdana.ttf'})
    font 'Verdana', :size => 10
  end
end