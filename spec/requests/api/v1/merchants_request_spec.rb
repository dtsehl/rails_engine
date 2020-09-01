require 'rails_helper'

RSpec.describe 'Api::V1::Merchants', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/merchants'
      expect(response).to have_http_status(:success)
    end
    it 'returns all merchants' do
      get '/api/v1/merchants'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].length).to eq(100)
      json[:data].each do |merchant|
        expect(merchant[:type]).to eq('merchant')
        expect(merchant[:attributes]).to have_key(:name)
      end
    end
  end

  describe 'GET /:id' do
    it 'returns http success' do
      get '/api/v1/merchants/42'
      expect(response).to have_http_status(:success)
    end
    it 'returns a merchant' do
      get '/api/v1/merchants/42'
      expected_attributes = {
        name: 'Glover Inc'
      }

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq('42')

      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
    it "returns an error if the merchant doesn't exist" do
      get '/api/v1/merchants/9999999999999'
      expect(response.status).to eq(404)
    end
  end

  describe 'POST/DELETE /merchants' do
    it 'creates/deletes a merchant successfully' do
      name = 'Dingle Hoppers'

      body = {
        name: name
      }

      post '/api/v1/merchants', params: {
        name: body[:name]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:success)
      new_merchant = json[:data]
      expect(new_merchant[:attributes][:name]).to eq(name)

      delete "/api/v1/merchants/#{new_merchant[:id]}"
      expect(response).to have_http_status(:success)

      expect(response.body).to be_empty
      expect(response.status).to eq(204)
    end
    it 'cannot create a merchant if the request is not made correctly' do
      post '/api/v1/merchants'

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:name]).to eq(["can't be blank"])
      expect(response).to have_http_status(422)
    end
  end

  describe 'PATCH /merchant/:id' do
    it 'updates a merchant' do
      name = 'Dingle Hoppers'

      body = {
        name: name
      }

      patch '/api/v1/merchants/99', params: {
        name: body[:name]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      item = json[:data]
      expect(item[:attributes][:name]).to eq(name)
    end
    it 'cannot update a merchant if the request is not made correctly' do
      patch '/api/v1/merchants/999999999999'

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:error]).to eq('not_found')
      expect(response).to have_http_status(404)
    end
  end
end
