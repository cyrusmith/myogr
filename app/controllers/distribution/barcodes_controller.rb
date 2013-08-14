# coding: utf-8
module Distribution
  class BarcodesController < Admin::AdminController

    def show
      @barcode = Barcode.find(params[:id])
      respond_to do |format|
        format.json { render json: @barcode }
        format.js
      end
    end

    def create
      unless params[:quantity].empty? or params[:owner].empty?
        barcode_quantity = params[:quantity].to_i
        begin
          barcodes = Barcode.create_batch params[:owner], current_user.id, barcode_quantity
        rescue Exception
          redirect_to new_distribution_barcode_path, flash: {alert: 'Произошла ошибка при создании штрих-кодов'}
        end
        print(barcodes)
      else
        redirect_to new_distribution_barcode_path, flash: {alert: 'Поля заполнены некорректно'}
      end
    end

    private

    def print(barcodes)
      output = BarcodeLabelForm.new(barcodes, view_context).to_pdf
      filename = Time.now.to_i.to_s
      File.open("barcodes/#{filename}.pdf", 'wb'){|f| f.write output }
      send_data output, :type => :pdf, :disposition => 'inline'
    end

  end
end
