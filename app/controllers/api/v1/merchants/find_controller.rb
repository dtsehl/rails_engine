class Api::V1::Merchants::FindController < ApplicationController
  def show
    merchant = if merchant_params_string.present?
                 Merchant.search_single_by_string(merchant_params_string)
               elsif merchant_params_num.present?
                 Merchant.search_single_by_num(merchant_params_num)
               else
                 Merchant.search_single_by_date(merchant_params_date)
               end
    if merchant.nil?
      record_not_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def index
    merchants = if merchant_params_string.present?
                  Merchant.search_multiple_by_string(merchant_params_string)
                elsif merchant_params_num.present?
                  Merchant.search_multiple_by_num(merchant_params_num)
                else
                  Merchant.search_multiple_by_date(merchant_params_date)
                end
    if merchants.empty?
      record_not_found
    else
      render json: MerchantSerializer.new(merchants)
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
