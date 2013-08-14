# encoding: utf-8
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class BarcodeLabelForm < Prawn::Document

  delegate :params, :h, :raw, :link_to, :number_to_currency, :point, to: :@view

  def initialize(barcodes, view)
    super(page_size: [170, 113], margin: [0, 17])
    @barcodes = barcodes
    @view = view
  end

  def to_pdf

    initFonts

    @barcodes.each do |barcode|
      barcodeGenerator = Barby::Code128B.new(barcode.barcode_string)
      outputter = Barby::PrawnOutputter.new(barcodeGenerator)
      outputter.annotate_pdf(self, xdim:0.7, y:50)
      move_down 67
      text('%06d' % barcode.owner + ' ' + '%08d' % barcode.value, align: :center, size: 14)
      move_down 2
      user = User.find(barcode.owner)
      text (user ? "Отправитель: #{user.display_name}" : 'Инвентаризация')
      start_new_page #в этом случае последняя этикетка будет пустой. Сделано так как без этого не оторвать ленту с напечатанными этикетками.
    end


    render
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