#encoding: utf-8
class CommonDocument < Prawn::Document

  delegate :params, :h, :raw, :link_to, :number_to_currency, to: :@view

  def initialize(view, options={})
    @view = view
    @numerate_pages = options.delete(:numerate_pages) || false
    super(options)
  end

  def to_pdf
    initFonts
    output

    numerate_pages if @numerate_pages
    render
  end

  protected

  def output
  end

  def numerate_pages
    for page in 1..page_count do
      go_to_page(page)
      bounding_box([bounds.right-250, bounds.bottom + 25], :width => 250) {
        text "Страница #{page} из #{page_count}", :align => :right, :style => :italic, :size => 6
      }
    end
  end

  def initFonts
    font_families.update(
        'Verdana' => {
            :bold => "#{Rails.root}/public/assets/font/verdanab.ttf",
            :italic => "#{Rails.root}/public/assets/font/verdanai.ttf",
            :normal => "#{Rails.root}/public/assets/font/verdana.ttf"
        }
    )
    font 'Verdana', :size => 10
  end

end