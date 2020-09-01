class Api::V1::MerchantsController < ApplicationController
  def show
    merchant = Merchant.find_by_id(params[:id])
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      render json: '{"error": "not_found"}', status: :not_found
    end
  end

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      render json: MerchantSerializer.new(Merchant.find(merchant.id))
    else
      render json: merchant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find_by_id(params[:id])
    if merchant.present?
      merchant.update(merchant_params)
      render json: MerchantSerializer.new(Merchant.find(merchant.id))
    else
      render json: '{"error": "not_found"}', status: :not_found
    end
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
