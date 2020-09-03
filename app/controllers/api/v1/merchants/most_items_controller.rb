class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    quantity = params[:quantity]
    merchants = Merchant.most_items(quantity)
    render json: MerchantSerializer.new(merchants)
  end
end
