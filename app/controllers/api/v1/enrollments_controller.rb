class Api::V1::EnrollmentsController < ApplicationController
  #   GET /api/v1/courses/:course_id/enrollments
  def index
    course = Course.find_by(id: params[:course_id])
    if course.nil?
      render json: { error: "Course not found" }, status: :not_found
      return
    end

    enrollments = course.enrollments.includes(:student)

    enrollment_data = enrollments.map do |enrollment|
      {
        id: enrollment.id,
        studentId: enrollment.student.id,
        studentFirstName: enrollment.student.first_name,
        studentLastName: enrollment.student.last_name,
        finalGrade: enrollment.final_grade || ""
      }
    end

    render json: { enrollments: enrollment_data }, status: :ok
  end
end