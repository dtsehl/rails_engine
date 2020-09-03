class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    quantity = params[:quantity]
    merchants = Merchant.most_revenue(quantity)
    render json: MerchantSerializer.new(merchants)
  end
end
