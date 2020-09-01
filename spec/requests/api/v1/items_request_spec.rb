require 'rails_helper'

RSpec.describe 'Api::V1::Items', type: :request do
  describe 'GET /show' do
    it 'returns http success' do
      get '/api/v1/items/179'
      expect(response).to have_http_status(:success)
    end
    it 'returns the correct data' do
      get '/api/v1/items/179'
      expected_attributes = {
        name: 'Item Qui Veritatis',
        description: 'Totam labore quia harum dicta eum consequatur qui. Corporis inventore consequatur. Illum facilis tempora nihil placeat rerum sint est. Placeat ut aut. Eligendi perspiciatis unde eum sapiente velit.',
        unit_price: 906.17,
        merchant_id: 9
      }

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq('179')

      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
  end

  describe 'GET /index'
  it 'returns http success' do
    get '/api/v1/items/179'
    expect(response).to have_http_status(:success)
  end
  it 'returns the correct data' do
    get '/api/v1/items'
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data].length).to eq(2483)
    json[:data].each do |item|
      expect(item[:type]).to eq('item')
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  describe 'POST/DELETE /items' do
    it 'creates/deletes an item successfully' do
      name = 'Shiny Itemy Item'
      description = 'It does a lot of things real good'
      unit_price = 5011.96
      merchant_id = 43

      body = {
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      post '/api/v1/items', params: {
        name: body[:name],
        description: body[:description],
        unit_price: body[:unit_price],
        merchant_id: body[:merchant_id]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:success)
      new_item = json[:data]
      expect(new_item[:attributes][:name]).to eq(name)
      expect(new_item[:attributes][:description]).to eq(description)
      expect(new_item[:attributes][:unit_price]).to eq(unit_price)
      expect(new_item[:attributes][:merchant_id]).to eq(merchant_id)

      delete "/api/v1/items/#{new_item[:id]}"
      expect(response).to have_http_status(:success)

      expect(response.body).to be_empty
      expect(response.status).to eq(204)
    end
    it 'cannot create an item if the request is not made correctly' do
      description = 'It does a lot of things real good'
      unit_price = 5011.96
      merchant_id = 43

      body = {
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      post '/api/v1/items', params: {
        description: body[:description],
        unit_price: body[:unit_price],
        merchant_id: body[:merchant_id]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:name]).to eq(["can't be blank"])
      expect(response).to have_http_status(422)
    end
  end

  describe 'PATCH /items/:id' do
    it 'updates an item' do
      name = 'Shiny Itemy Item'
      description = 'It does a lot of things real good'
      unit_price = 5011
      merchant_id = 43

      body = {
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      patch '/api/v1/items/75', params: {
        name: body[:name],
        description: body[:description],
        unit_price: body[:unit_price],
        merchant_id: body[:merchant_id]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      item = json[:data]
      expect(item[:attributes][:name]).to eq(name)
      expect(item[:attributes][:description]).to eq(description)
      expect(item[:attributes][:unit_price]).to eq(unit_price)
      expect(item[:attributes][:merchant_id]).to eq(merchant_id)
    end
    it 'cannot update an item if the request is not made correctly' do
      name = 'A name'
      description = 'A cool item'
      unit_price = 123.45
      merchant_id = 9_999_999_999_999

      body = {
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant_id
      }

      patch '/api/v1/items/75', params: {
        description: body[:description],
        unit_price: body[:unit_price],
        merchant_id: body[:merchant_id]
      }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:merchant]).to eq(['must exist'])
      expect(response).to have_http_status(422)
    end
  end
end