require 'rails_helper'

RSpec.describe "Api::V1::Students", type: :request do
  describe "POST /api/v1/students" do
    let(:valid_attributes) do
      {
        student: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: 'validstudent@example.com'
        }
      }
    end

    let(:invalid_attributes) do
      {
        student: {
          first_name: "",
          last_name: "",
          email: ""
        }
      }
    end

    it "creates a new student" do
      expect {
        post '/api/v1/students', params: valid_attributes
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['student']['email']).to eq("validstudent@example.com")
    end

    it "Does not create a new student with invalid data and returns errors" do
        expect {
          post '/api/v1/students', params: invalid_attributes
        }.not_to change(Student, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include(
          a_string_including("First name"),
          a_string_including("Last name"),
          a_string_including("Email")
        )
    end

    it "Does not allow creating a student with duplicate email" do
      Student.create!(valid_attributes[:student])

      duplicate_email_attributes = {
        student: {
          first_name: "Dublicate",
          last_name: "Student",
          email: valid_attributes[:student][:email]
        }
      }

      expect {
        post '/api/v1/students', params: duplicate_email_attributes
      }.not_to change(Student, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Email has already been taken")
    end

  end
end
