require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end
  describe 'Validations' do
    it { should validate_presence_of :name }
  end
  describe 'Class methods' do
    it '.search_single_by_string' do
      params = ActionController::Parameters.new({
                                                  name: 'hel'
                                                })
      merchant = Merchant.search_single_by_string(params)
      expect(merchant.class).to eq(Merchant)
    end
    it '.search_single_by_num' do
      params = ActionController::Parameters.new({
                                                  id: 3
                                                })
      merchant = Merchant.search_single_by_num(params)
      expect(merchant.class).to eq(Merchant)
    end
    it '.search_single_by_date' do
      params = ActionController::Parameters.new({
                                                  created_at: '2012-03-27 14:53:59 UTC'
                                                })
      merchant = Merchant.search_single_by_date(params)
      expect(merchant.class).to eq(Merchant)
      params = ActionController::Parameters.new({
                                                  updated_at: '2012-03-27 14:53:59 UTC'
                                                })
      merchant = Merchant.search_single_by_date(params)
      expect(merchant.class).to eq(Merchant)
    end
    it '.search_multiple_by_string' do
      params = ActionController::Parameters.new({
                                                  name: 'hel'
                                                })
      merchants = Merchant.search_multiple_by_string(params)
      expect(merchants.first.class).to eq(Merchant)
    end
    it '.search_multiple_by_num' do
      params = ActionController::Parameters.new({
                                                  id: 3
                                                })
      merchants = Merchant.search_multiple_by_num(params)
      expect(merchants.first.class).to eq(Merchant)
    end
    it '.search_multiple_by_date' do
      params = ActionController::Parameters.new({
                                                  created_at: '2012-03-27 14:53:59 UTC'
                                                })
      merchants = Merchant.search_multiple_by_date(params)
      expect(merchants.first.class).to eq(Merchant)
      params = ActionController::Parameters.new({
                                                  updated_at: '2012-03-27 14:53:59 UTC'
                                                })
      merchants = Merchant.search_multiple_by_date(params)
      expect(merchants.first.class).to eq(Merchant)
    end
    it '.most_revenue' do
      quantity = 7
      merchants = Merchant.most_revenue(quantity)
      expect(merchants.first.class).to eq(Merchant)
      expect(merchants.length).to eq(quantity)
    end
    it '.most_items' do
      quantity = 7
      merchants = Merchant.most_items(quantity)
      expect(merchants.first.class).to eq(Merchant)
      expect(merchants.length).to eq(quantity)
    end
  end
end
