class TrainingsController < ApplicationController
  #Displays all current user trainings.  
  def show
  	if !current_user.protege.nil? 
  		@trainings = current_user.protege.training
	elsif !current_user.trainer.proteges.nil? 
  		@trainings = User.find(params[:id]).protege.training
  	end
  end

  #Displays selected training.
  def show_details
  	if params[:id]
  		@training = Training.find(params[:id])
  	else	
  		redirect_to root_url
  	end
end

	def create_training_mobile
		if(!params[:protege_id].nil?)
			@training = Training.new(training_mobile)
			@training.save
			render json: {status: "success", training: @training}
		else
			render json: {status: "failure"}
		end
	end

	def end_training_mobile
		if(!params[:id].nil?)
			@training = Training.find(params[:id])
			@training.end = Time.now.strftime("%Y-%m-%d %H:%M:%S")
			@old_active_excercise = ActiveExcercise.where("training_id = ?", @training.id)
			@old_active_excercise.each do |p|
				@done_excercise = DoneExcercise.new(p.attributes)
				@done_excercise.save
			end
			@old_active_excercise.destroy_all
			if @training.save
				render json: {status: "success", training: @training}
			else
				render json: {status: "failure"}
			end
		else
			render json: {status: "failure"}
		end

	end

	def trainings_index_mobile
		@trainings = Training.where("start is not null").order(start: :desc)
		render json: @trainings
	end

	private
	def training_mobile
		params.permit(:protege_id, :start, :end, :comment)
	end
end
