# encoding: utf-8
class PackageListReport < Prawn::Document
  delegate :h, :raw, :t, to: :@view
  Widths = [50, 110, 75, 40, 75, 70, 110]
  Headers = ['№', 'Id/Ник', 'Документ', 'Мест', 'Дата получения', 'Сумма за просрочку', 'Подпись']

  def initialize(package_list, view)
    super()
    @package_list = package_list
    @view = view
    @@tables = 0
  end

  def to_pdf
    font_families.update(
        'Verdana' => {
            :bold => "#{Rails.root}/public/assets/font/verdanab.ttf",
            :italic => "#{Rails.root}/public/assets/font/verdanai.ttf",
            :normal => "#{Rails.root}/public/assets/font/verdana.ttf"
        }
    )
    font 'Verdana', :size => 10
    Distribution::Package::METHODS.each do |method_name|
      new_list(@package_list.packages.distribution_method(method_name).sort{|a,b| a.order.to_i <=> b.order.to_i}, method_name)
    end
    render
  end

  private

  def new_list(dataset, method)
    unless dataset.empty?
      start_new_page if @@tables > 0
      start_page = page_count
      formatted_package_date = Russian::strftime @package_list.date, '%d.%m.%y'
      text "Ведомость от #{formatted_package_date} / #{t('distribution.package.methods.' + method.to_s)}", :size => 12, :style => :bold
      move_down 5
      text "Центр раздач: #{@package_list.point.address.full_address}"
      new_package_table dataset
      @@tables += 1
      creation_date = Time.now.strftime("Лист сгенерирован %e %b %Y %H:%M")
      i = 1
      total_pages = page_count - start_page
      for page in start_page..page_count do
        go_to_page(page)
        bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
          text creation_date, :align => :right, :style => :italic, :size => 6
          text "Страница #{i} из #{total_pages}", :align => :right, :style => :italic, :size => 6
        }
        i += 1
      end
    end
  end

  def new_package_table(dataset)
    head = make_table([Headers], :column_widths => Widths) do |t|
      t.row(0).align = :center
      t.row(0).valign = :center
      t.row(0).font_style = :bold
    end
    data = []
    dataset.each do |row|
      username = row.user.nil? ? "" : "#{row.user.id}/#{row.user.display_name}"
      data << new_row(row.order, username, row.document_number, row.items.count)
    end
    table([[head], *(data.map { |d| [d] })], :header => true, :row_colors => %w[ffffff]) do
      row(0).style :background_color => 'cccccc'
    end
  end

  def new_row(order, user, doc_num, orders_num)
    row = [order, CGI.unescapeHTML(user)[0..17], CGI.unescapeHTML(doc_num), orders_num, '', '', '']
    make_table([row]) do |t|
      t.column_widths = Widths
      t.columns(0).size = 14
      t.columns(0).font_style = :bold
      t.columns([0,2,3]).align = :center
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end

end