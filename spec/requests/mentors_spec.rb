require 'rails_helper'

RSpec.describe 'Mentors', type: :request do
  describe 'GET /mentors' do
    context 'when mentors do exist' do
      before do
        Mentor.create!(
          first_name: 'Albus',
          last_name: 'Dumbledore',
          email: 'dumbledore@owlspost.com',
          max_concurrent_students: 3
        )

        Mentor.create!(
          first_name: 'Severus',
          last_name: 'Snape',
          email: 'snape@owlspost.com',
          max_concurrent_students: 5
        )
      end

      it 'returns a page with the list of mentors with details' do
        get '/mentors'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Albus')
        expect(response.body).to include('Severus')
        expect(response.body).to include('First name:')
      end
    end

    context 'when mentors do not exist' do
      it 'returns a page with just a heading' do
        get '/mentors'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Mentors')
        expect(response.body).not_to include('First name:')
      end
    end
  end

  describe 'GET /mentors/:id' do
    context 'when the mentor exists' do
      let!(:mentor) do
        Mentor.create!(
          first_name: 'Severus',
          last_name: 'Snape',
          email: 'snape@owlspost.com',
          max_concurrent_students: 5
        )
      end

      it 'returns a page with the mentor’s details' do
        get "/mentors/#{mentor.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Severus')
        expect(response.body).to include('Snape')
        expect(response.body).to include('snape@owlspost.com')
        expect(response.body).to include('Max concurrent students:')
      end
    end

    context 'when the mentor does not exist' do
      it 'returns 404 page' do
        get '/mentors/666'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end