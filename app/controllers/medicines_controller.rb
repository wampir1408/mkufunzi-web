class MedicinesController < ApplicationController
  def new
  	@medicine = Medicine.new(medicine_params)
  	if @medicine.save
  		flash[:success] = "Lek został dodany"
  	else
  		flash[:danger] = "coś poszło nie tak..."
  	end
  	redirect_to my_medicines_path
  end

  def show
  	@my_medicines = User.find(current_user.id).protege.medicines
  	@medicine = Medicine.new
  	  	@medicine_time = MedicineTime.new

  end

  private

    def medicine_params
  		params.require(:medicine_time).permit(:name, :dose, :dose_unit, :protege_id)
  	end
end
