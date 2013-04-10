class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.json
  def index
    @results = Product.where("lower(name) like lower(:value)", value: "%#{params['search']}%")
    .joins("JOIN ibf_topics topics ON #{Product.table_name}.tid = topics.tid")
    .where('topics.color = 2 OR topics.color = 1')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @results }
    end
  end
end
