class AdminDashboardController < ApplicationController

   before_action :require_admin
  def index
     @current_trimester = Trimester.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)

     @upcoming_trimester = Trimester
      .where("start_date > ? AND start_date <= ?", Date.today, Date.today + 6.months)
      .order(:start_date)
      .first
  end
end  