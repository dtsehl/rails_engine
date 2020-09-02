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
    it "returns an error if the item doesn't exist" do
      get '/api/v1/items/9999999999999'
      expect(response.status).to eq(404)
    end
  end

  describe 'GET /index'
  it 'returns http success' do
    get '/api/v1/items'
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

  describe 'Relationships' do
    it 'can get merchant for an item' do
      get '/api/v1/items/209/merchant'
      json = JSON.parse(response.body, symbolize_names: true)
      expected_id = '11'

      expect(json[:data][:id]).to eq(expected_id)
    end
  end

  describe 'search endpoints' do
    it 'can find an item based on a fragmented name, case insensitive' do
      get '/api/v1/items/find?name=haru'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('haru')
    end
    it 'can find an item based on a fragmented description, case insensitive' do
      get '/api/v1/items/find?description=nesc'
      json = JSON.parse(response.body, symbolize_names: true)
      description = json[:data][:attributes][:description].downcase

      expect(json[:data]).to be_a(Hash)
      expect(description).to include('nesc')
    end
    it 'can find an item based on a unit price' do
      get '/api/v1/items/find?unit_price=751.07'
      json = JSON.parse(response.body, symbolize_names: true)
      unit_price = json[:data][:attributes][:unit_price]

      expect(json[:data]).to be_a(Hash)
      expect(unit_price).to eq(751.07)
    end
    it 'can find an item based on a merchant id' do
      get '/api/v1/items/find?merchant_id=3'
      json = JSON.parse(response.body, symbolize_names: true)
      merchant_id = json[:data][:attributes][:merchant_id]

      expect(json[:data]).to be_a(Hash)
      expect(merchant_id).to eq(3)
    end
    it 'can find an item based on its id' do
      get '/api/v1/items/find?id=1'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('item qui esse')
    end
    it 'can find an item based on its created_at' do
      get '/api/v1/items/find?created_at=2012-03-27 14:53:59 UTC'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('item qui esse')
    end
    it 'can find an item based on its updated_at' do
      get '/api/v1/items/find?updated_at=2012-03-27 14:54:00 UTC'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('item inventore sint')
    end
    it 'will error if the params are incorrect' do
      get '/api/v1/items/find?id=9999999'

      expect(response).to have_http_status(404)
    end
  end
end
