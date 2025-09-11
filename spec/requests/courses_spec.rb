require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe 'GET /courses/:id' do
    before do
      @trimester = Trimester.create!(
        term: 'Test Current Term',
        year: Date.today.year.to_s,
        start_date: Date.today - 1.month,
        end_date: Date.today + 2.months,
        application_deadline: Date.today - 2.months
        )
      @coding_class = CodingClass.create!(title: "Test Course")
      @course = Course.create!(coding_class: @coding_class, trimester: @trimester)
      @students = []

      2.times do |i|
        student = Student.create!(
          first_name: "Student#{i + 1}",
          last_name: "Test#{i + 1}",
          email: "student#{i + 1}@example.com"
        )
        Enrollment.create!(student: student, course: @course)
        @students << student
      end
    end

    it 'displays the course title and enrolled student name' do
      # Send a GET request to the dashboard route
      get "/courses/#{@course.id}"

      # Check that the response status is 200 (OK)
      expect(response).to have_http_status(:ok)
      # Check that the course title is displayed
      expect(response.body).to include(@course.coding_class.title)
      # Check that the students names are displayed
      @students.each do |student|
        expect(response.body).to include(student.first_name)
        expect(response.body).to include(student.last_name)
      end
    end
  end
end