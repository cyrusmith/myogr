module Admin
  module Salon
    class EmployeesController < ApplicationController
      # GET /admin/salon/employees
      # GET /admin/salon/employees.json
      def index
        @admin_salon_employees = Admin::Salon::Employee.all

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @admin_salon_employees }
        end
      end

      # GET /admin/salon/employees/1
      # GET /admin/salon/employees/1.json
      def show
        @admin_salon_employee = Admin::Salon::Employee.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @admin_salon_employee }
        end
      end

      # GET /admin/salon/employees/new
      # GET /admin/salon/employees/new.json
      def new
        @admin_salon_employee = Admin::Salon::Employee.new

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @admin_salon_employee }
        end
      end

      # GET /admin/salon/employees/1/edit
      def edit
        @admin_salon_employee = Admin::Salon::Employee.find(params[:id])
      end

      # POST /admin/salon/employees
      # POST /admin/salon/employees.json
      def create
        @admin_salon_employee = Admin::Salon::Employee.new(params[:admin_salon_employee])

        respond_to do |format|
          if @admin_salon_employee.save
            format.html { redirect_to @admin_salon_employee, notice: 'Employee was successfully created.' }
            format.json { render json: @admin_salon_employee, status: :created, location: @admin_salon_employee }
          else
            format.html { render action: "new" }
            format.json { render json: @admin_salon_employee.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /admin/salon/employees/1
      # PUT /admin/salon/employees/1.json
      def update
        @admin_salon_employee = Admin::Salon::Employee.find(params[:id])

        respond_to do |format|
          if @admin_salon_employee.update_attributes(params[:admin_salon_employee])
            format.html { redirect_to @admin_salon_employee, notice: 'Employee was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @admin_salon_employee.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /admin/salon/employees/1
      # DELETE /admin/salon/employees/1.json
      def destroy
        @admin_salon_employee = Admin::Salon::Employee.find(params[:id])
        @admin_salon_employee.destroy

        respond_to do |format|
          format.html { redirect_to admin_salon_employees_url }
          format.json { head :no_content }
        end
      end
    end

  end
end

