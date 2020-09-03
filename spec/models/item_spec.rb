require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end
  describe 'Class methods' do
    it '.search_single_by_string' do
      params = ActionController::Parameters.new({
                                                  name: 'i'
                                                })
      item = Item.search_single_by_string(params)
      expect(item.class).to eq(Item)
    end
    it '.search_single_by_num' do
      params = ActionController::Parameters.new({
                                                  id: 3
                                                })
      item = Item.search_single_by_num(params)
      expect(item.class).to eq(Item)
    end
    it '.search_single_by_date' do
      params = ActionController::Parameters.new({
                                                  created_at: '2012-03-27 14:53:59 UTC'
                                                })
      item = Item.search_single_by_date(params)
      expect(item.class).to eq(Item)
      params = ActionController::Parameters.new({
                                                  updated_at: '2012-03-27 14:53:59 UTC'
                                                })
      item = Item.search_single_by_date(params)
      expect(item.class).to eq(Item)
    end
    it '.search_multiple_by_string' do
      params = ActionController::Parameters.new({
                                                  name: 'i'
                                                })
      items = Item.search_multiple_by_string(params)
      expect(items.first.class).to eq(Item)
    end
    it '.search_multiple_by_num' do
      params = ActionController::Parameters.new({
                                                  id: 3
                                                })
      items = Item.search_multiple_by_num(params)
      expect(items.first.class).to eq(Item)
    end
    it '.search_multiple_by_date' do
      params = ActionController::Parameters.new({
                                                  created_at: '2012-03-27 14:53:59 UTC'
                                                })
      items = Item.search_multiple_by_date(params)
      expect(items.first.class).to eq(Item)
      params = ActionController::Parameters.new({
                                                  updated_at: '2012-03-27 14:53:59 UTC'
                                                })
      items = Item.search_multiple_by_date(params)
      expect(items.first.class).to eq(Item)
    end
  end
end
