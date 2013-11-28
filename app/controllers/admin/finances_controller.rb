class Admin::FinancesController < Admin::AdminController
  skip_load_and_authorize_resource
  authorize_resource class: false

  def index
    @incomes = FinanceStat.year_income(params[:date] ? Date.parse(params[:date]) : Date.today )
    @earnings = FinanceStat.year_earnings(params[:date] ? Date.parse(params[:date]) : Date.today )
  end
end
