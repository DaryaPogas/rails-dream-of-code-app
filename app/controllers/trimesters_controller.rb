class TrimestersController < ApplicationController

    def index
        @trimesters = Trimester.all
    end
 
    def show
        @trimester = Trimester.find(params[:id])
    end

    def edit
    @trimester = Trimester.find(params[:id])
  end

  def update
    @trimester = Trimester.find_by(id: params[:id])
    return render plain: "Trimester not found", status: :not_found unless @trimester

    input = params[:trimester][:application_deadline]

    if input.blank?
      @trimester.errors.add(:application_deadline, "can not be blank")
      return render :edit, status: :bad_request
    end

    begin
      Date.parse(input)
    rescue ArgumentError
      @trimester.errors.add(:application_deadline, "must look like a date")
      return render :edit, status: :bad_request
    end

    if @trimester.update(application_deadline: input)
      redirect_to @trimester, notice: "Trimester updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end  

  private

  def trimester_params
    params.require(:trimester).permit(:application_deadline)
  end
end