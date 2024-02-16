require 'rails_helper'
require 'auth_helper'
require 'faker'

RSpec.describe UsersController, type: :controller do
  let(:role) { create(:custom_role) }
  let!(:user) { FactoryBot.create(:user, role_id: role.id, name: "abc") }
  let(:token_new) { encode_token(id: user.id) }
  let(:token) { "Bearer #{token_new}" }

  describe 'GET #index' do
    context 'with email parameter' do
      it 'renders JSON with email' do
        request.headers["Authorization"] = token
        get :index, params: { email: Faker::Internet.email }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with name parameter' do
      it 'renders JSON with matching name' do
        request.headers["Authorization"] = token
        get :index, params: { name: "abc" }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.any? { |user| user["name"] == "abc" }).to be true
      end
    end

    context 'without any parameter' do
      it 'renders JSON with matching name' do
        request.headers["Authorization"] = token
        get :index, params: {  } # Provide the name parameter
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.any? { |user| user["name"] == "abc" }).to be true
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get :index, params: { email: Faker::Internet.email }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      let(:invalid_token) { "Bearer invalid_token" }

      it 'returns unauthorized' do
        request.headers["Authorization"] = invalid_token
        get :index, params: { email: Faker::Internet.email }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 8)} }

    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(1)
      end

      it 'returns a JSON response with the new user and token' do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['user']['name']).to eq(valid_params[:name])
        expect(json_response['user']['email']).to eq(valid_params[:email])
        expect(json_response['token']).not_to be_empty
      end
    end
  end

  describe 'POST #login' do
    it "log in user" do
      post :login, params: {
        email: "rohan@gmail.com",
        password: "123"
      }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe 'PUT #update' do
    it "updates user" do
      request.headers["Authorization"] = token
      put :update, params: {
        id: user.id,
        user: {
          name: Faker::Name.name
        }
      }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe 'DELETE #destroy' do
    it "delete user" do
      request.headers["Authorization"]=token
      delete :destroy, params: {
        id: user.id,
      }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
