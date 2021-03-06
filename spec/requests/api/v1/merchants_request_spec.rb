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

  describe 'Relationships' do
    it 'can get items for a merchant' do
      get '/api/v1/merchants/99/items'
      json = JSON.parse(response.body, symbolize_names: true)
      expected_ids =
        [
          2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406,
          2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2416,
          2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426,
          2427, 2428, 2429, 2430, 2431, 2432, 2433, 2434, 2435, 2436,
          2437, 2438
        ]
      item_ids = json[:data].map do |item|
        item[:id].to_i
      end
      expect(item_ids.sort).to eq(expected_ids)
    end
  end

  describe 'search endpoints' do
    it 'can find a merchant based on a fragmented name, case insensitive' do
      get '/api/v1/merchants/find?name=ILL'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('ill')
    end
    it 'can find a merchant based on its id' do
      get '/api/v1/merchants/find?id=1'
      json = JSON.parse(response.body, symbolize_names: true)
      name = json[:data][:attributes][:name].downcase

      expect(json[:data]).to be_a(Hash)
      expect(name).to include('schroeder-jerde')
    end
    it 'can find a merchant based on its created_at' do
      get '/api/v1/merchants/find?created_at=2012-03-27 14:54:07 UTC'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_a(Hash)
    end
    it 'can find a merchant based on its updated_at' do
      get '/api/v1/merchants/find?updated_at=2012-03-27 14:54:02 UTC'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_a(Hash)
    end
    it 'will error if the find params are incorrect' do
      get '/api/v1/merchants/find?id=9999999'

      expect(response).to have_http_status(404)
    end
  end
  it "can find a list of merchants by name that contain a fragment, case insensitive" do
    get '/api/v1/merchants/find_all?name=ILL'
    json = JSON.parse(response.body, symbolize_names: true)

    names = json[:data].map do |merchant|
      merchant[:attributes][:name]
    end

    expect(names.sort).to eq(["Schiller, Barrows and Parker", "Tillman Group", "Williamson Group", "Williamson Group", "Willms and Sons"])
  end
  it "can find a list of merchants by id" do
    get '/api/v1/merchants/find_all?id=5'
    json = JSON.parse(response.body, symbolize_names: true)

    ids = json[:data].map do |item|
      item[:attributes][:id]
    end

    expect(ids.count).to eq(1)
    ids.each do |id|
      expect(id).to eq(5)
    end
  end
  it "can find a list of merchants by created_at" do
    get '/api/v1/merchants/find_all?created_at=2012-03-27 14:53:59 UTC'
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].count).to eq(9)
  end
  it "can find a list of merchants by updated_at" do
    get '/api/v1/merchants/find_all?updated_at=2012-03-27 14:53:59 UTC'
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].count).to eq(8)
  end
  it 'will error if the find_all params are incorrect' do
    get '/api/v1/merchants/find_all?name=zzzzzzzzz'

    expect(response).to have_http_status(404)
  end

  describe 'business intelligence' do
    it 'can get merchants with most revenue' do
      get "/api/v1/merchants/most_revenue?quantity=7"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].length).to eq(7)

      expect(json[:data][0][:attributes][:name]).to eq("Dicki-Bednar")
      expect(json[:data][0][:id]).to eq("14")

      expect(json[:data][3][:attributes][:name]).to eq("Bechtelar, Jones and Stokes")
      expect(json[:data][3][:id]).to eq("10")

      expect(json[:data][6][:attributes][:name]).to eq("Rath, Gleason and Spencer")
      expect(json[:data][6][:id]).to eq("53")
    end
    it 'can get merchants who have sold the most items' do
      get "/api/v1/merchants/most_items?quantity=8"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].length).to eq(8)

      expect(json[:data][0][:attributes][:name]).to eq("Kassulke, O'Hara and Quitzon")
      expect(json[:data][0][:id]).to eq("89")

      expect(json[:data][3][:attributes][:name]).to eq("Okuneva, Prohaska and Rolfson")
      expect(json[:data][3][:id]).to eq("98")

      expect(json[:data][7][:attributes][:name]).to eq("Terry-Moore")
      expect(json[:data][7][:id]).to eq("84")
    end
  end
end
