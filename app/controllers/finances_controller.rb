class FinancesController < ApplicationController
  layout 'admin'

  authorize_resource class: false

  def index
    date = params[:year] ? Date.parse(params[:year]) : Date.today
    @incomes = FinanceStat.year_income(date)
    @earnings = FinanceStat.year_earnings(date)
  end
end
