require 'rails_helper'

RSpec.describe "Trimesters", type: :request do
  describe "GET /trimesters" do
    context 'trimesters exist' do
      before do
        (1..2).each do |i|
          Trimester.create!(
            term: "Term #{i}",
            year: '2025',
            start_date: '2025-01-01',
            end_date: '2025-01-01',
            application_deadline: '2025-01-01',
          )
        end
      end

      it 'returns a page containing names of all trimesters' do
        get '/trimesters'
        expect(response.body).to include('Term 1 2025')
        expect(response.body).to include('Term 2 2025')
      end
    end

    context 'trimesters do not exist' do
      it 'returns a page with a heading and empty list of trimesters' do
        get '/trimesters'
        expect(response.body).to include('Trimesters')
        expect(response.body).not_to include('<li>')
      end
    end
  end

  describe "GET /trimesters/:id/edit" do
    it "renders the edit form with application deadline label" do
      trimester = Trimester.create!(
        term: "Fall",
        year: 2025,
        start_date: "2025-10-01",
        end_date: "2026-02-26",
        application_deadline: "2025-09-01"
      )

      get edit_trimester_path(trimester)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Application Deadline")
    end
  end

  describe "PUT /trimesters/:id" do
    let!(:trimester) do
      Trimester.create!(
        term: "Spring",
        year: 2025,
        start_date: "2025-02-15",
        end_date: "2025-06-30",
        application_deadline: "2025-01-01"
      )
    end

    context "with valid application deadline" do
      it "updates the trimester and redirects" do
        put trimester_path(trimester), params: {
          trimester: { application_deadline: "2025-03-01" }
        }

        expect(response).to redirect_to(trimester_path(trimester))
        follow_redirect!
        expect(response.body).to include("Trimester updated successfully.")
        expect(trimester.reload.application_deadline).to eq(Date.parse("2025-03-01"))
      end
    end

    context "without application deadline" do
      it "returns 400 Bad Request" do
        put trimester_path(trimester), params: {
          trimester: { application_deadline: "" }
        }

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("can not be blank")
      end
    end

    context "with invalid application deadline format" do
      it "returns 400 Bad Request" do
        put trimester_path(trimester), params: {
          trimester: { application_deadline: "invalid-date" }
        }

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("must look like a date")
      end
    end

    context "with non-existent trimester id" do
      it "returns 404" do
        put "/trimesters/1000", params: {
          trimester: { application_deadline: "2025-12-31" }
        }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Trimester not found")
      end
    end
  end
end