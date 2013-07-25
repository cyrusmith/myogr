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
      message = unless params[:quantity].empty? or params[:owner].empty?
                  barcode_quantity = params[:quantity].to_i
                  begin
                    Barcode.create_batch params[:owner], current_user.id, barcode_quantity
                  rescue Exception
                    {alert: 'Произошла ошибка при создании штрих-кодов'}
                  end
                  {success: 'Штрих-коды были успешно созданы'}
                else
                  {alert: 'Поля заполнены некорректно'}
                end
      redirect_to new_distribution_barcode_path, flash: message
    end

    def attach
      @owner_items = Distributor.owned(current_user.id)
    end

  end
end
