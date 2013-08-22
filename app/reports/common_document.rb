class CommonDocument < Prawn::Document

  delegate :params, :h, :raw, :link_to, :number_to_currency, to: :@view

  def initialize(view, options={})
    super(options)
    @view = view
  end

  def to_pdf
    initFonts
    output
    render
  end

  protected

  def output
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