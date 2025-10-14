class Api::V1::CoursesController < ApplicationController

  def index
    today = Date.today
    current_trimester = Trimester.find_by("start_date <= ? AND end_date >= ?", today, today)

    if current_trimester.nil?
      render json: { error: "Current trimester not found" }, status: :not_found
      return
    end

    courses = Course.where(trimester_id: current_trimester.id).includes(:coding_class)

    course_list = courses.map do |course|
      {
        id: course.id,
        title: course.coding_class.title,
        application_deadline: current_trimester.application_deadline.to_s,
        start_date: current_trimester.start_date.to_s,
        end_date: current_trimester.end_date.to_s
      }
    end

    render json: { courses: course_list }, status: :ok
  end

end
