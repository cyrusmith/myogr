module Distribution
  class PackagesController < ApplicationController
    # GET /distribution/packages
    # GET /distribution/packages.json
    def index
      @distribution_packages = Distribution::Package.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @distribution_packages }
      end
    end

    # GET /distribution/packages/1
    # GET /distribution/packages/1.json
    def show
      @distribution_package = Distribution::Package.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @distribution_package }
      end
    end

    # GET /distribution/packages/new
    # GET /distribution/packages/new.json
    def new
      @distribution_package = Distribution::Package.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @distribution_package }
      end
    end

    # GET /distribution/packages/1/edit
    def edit
      @distribution_package = Distribution::Package.find(params[:id])
    end

    # POST /distribution/packages
    # POST /distribution/packages.json
    def create
      @distribution_package = Distribution::Package.new(params[:distribution_package])

      respond_to do |format|
        if @distribution_package.save
          format.html { redirect_to @distribution_package, notice: 'Package was successfully created.' }
          format.json { render json: @distribution_package, status: :created, location: @distribution_package }
        else
          format.html { render action: "new" }
          format.json { render json: @distribution_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /distribution/packages/1
    # PUT /distribution/packages/1.json
    def update
      @distribution_package = Distribution::Package.find(params[:id])

      respond_to do |format|
        if @distribution_package.update_attributes(params[:distribution_package])
          format.html { redirect_to @distribution_package, notice: 'Package was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @distribution_package.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /distribution/packages/1
    # DELETE /distribution/packages/1.json
    def destroy
      @distribution_package = Distribution::Package.find(params[:id])
      @distribution_package.destroy

      respond_to do |format|
        format.html { redirect_to distribution_packages_url }
        format.json { head :no_content }
      end
    end
  end
end
