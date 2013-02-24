module Admin
  module Salon
    class ProceduresController < ApplicationController
      # GET /admin/salon/procedures
      # GET /admin/salon/procedures.json
      def index
        @admin_salon_procedures = Admin::Salon::Procedure.all

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @admin_salon_procedures }
        end
      end

      # GET /admin/salon/procedures/1
      # GET /admin/salon/procedures/1.json
      def show
        @salon_procedure = Admin::Salon::Procedure.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @salon_procedure }
        end
      end

      # GET /admin/salon/procedures/new
      # GET /admin/salon/procedures/new.json
      def new
        @salon_procedure = Admin::Salon::Procedure.new
        @group_array = Admin::Salon::Procedure.possible_groups.each {|group| group.unshift(t(group[0]))}
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @salon_procedure }
        end
      end

      # GET /admin/salon/procedures/1/edit
      def edit
        @salon_procedure = Admin::Salon::Procedure.find(params[:id])
      end

      # POST /admin/salon/procedures
      # POST /admin/salon/procedures.json
      def create
        @salon_procedure = Admin::Salon::Procedure.new(params[:admin_salon_procedure])

        respond_to do |format|
          if @salon_procedure.save
            format.html { redirect_to @salon_procedure, notice: 'Procedure was successfully created.' }
            format.json { render json: @salon_procedure, status: :created, location: @salon_procedure }
          else
            format.html { render action: "new" }
            format.json { render json: @salon_procedure.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /admin/salon/procedures/1
      # PUT /admin/salon/procedures/1.json
      def update
        @salon_procedure = Admin::Salon::Procedure.find(params[:id])

        respond_to do |format|
          if @salon_procedure.update_attributes(params[:admin_salon_procedure])
            format.html { redirect_to @salon_procedure, notice: 'Procedure was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @salon_procedure.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /admin/salon/procedures/1
      # DELETE /admin/salon/procedures/1.json
      def destroy
        @salon_procedure = Admin::Salon::Procedure.find(params[:id])
        @salon_procedure.destroy

        respond_to do |format|
          format.html { redirect_to admin_salon_procedures_url }
          format.json { head :no_content }
        end
      end
    end
  end
end
