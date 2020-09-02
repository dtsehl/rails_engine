class Api::V1::Merchants::FindController < ApplicationController
  def show
    if merchant_params_string.present?
      merchant = Merchant.search_by_string(merchant_params_string)
    elsif merchant_params_num.present?
      merchant = Merchant.search_by_num(merchant_params_num)
    else
      merchant = Merchant.search_by_date(merchant_params_date)
    end
    if merchant.nil?
      record_not_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  private

  def merchant_params_string
    params.permit(:name)
  end

  def merchant_params_num
    params.permit(:id)
  end

  def merchant_params_date
    params.permit(:created_at, :updated_at)
  end
end
