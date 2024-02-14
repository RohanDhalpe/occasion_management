require 'rails_helper'
require 'auth_helper'
require 'faker'

RSpec.describe VenuesController, type: :controller do
  let(:role) { create(:custom_role) }
  let!(:user) { FactoryBot.create(:user, role_id: role.id, name: "abc") }
  let(:token_new) { encode_token(id: user.id) }
  let(:token) { "Bearer #{token_new}" }
  let!(:venues) { FactoryBot.create_list(:venue, 3) }
  let(:venue) { venues.first }

  describe 'GET #index' do
    it 'Get venue with venue_type' do
      request.headers["Authorization"] = token
      get :index, params: {
        venue_type: 'GROUND'
      }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    context 'without token' do
      it 'returns unauthorized' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      let(:invalid_token) { "Bearer invalid_token" }

      it 'returns unauthorized' do
        request.headers["Authorization"] = invalid_token
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST #create" do
    it 'Venue Created successfully' do
      request.headers["Authorization"] = token
      post :create, params: {
        venue: {
          name: "Sample Venue",
          venue_type: "Conference Hall",
          start_time: "09:00:00",
          end_time: "17:00:00"
        }
      }
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'Venue if not able to create' do
      request.headers['Authorization'] = token
      post :create, params: {
        venue: {
          name: '',
          venue_type: 'Conference Hall',
          start_time: '09:00:00',
          end_time: '17:00:00'
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq({ 'error' => ["Name can't be blank"] })
    end
  end

  describe "PUT #update" do
    it 'Updated successfully' do
      venue = create(:venue) # Create a venue to be updated
      request.headers["Authorization"] = token
      put :update, params: {
        id: venue.id, # Provide the id of the venue to be updated
        venue: {
          name: "Updated Venue",
          venue_type: "Updated Conference Hall",
          start_time: "09:00:00",
          end_time: "17:00:00"
        }
      }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe 'DELETE #destroy' do
   it "delete venue" do
    request.headers["Authorization"] = "Bearer #{token}"
    delete :destroy, params: {
      id: venue.id,
    }
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json; charset=utf-8')
  end
 end
end
