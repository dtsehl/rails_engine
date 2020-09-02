class Api::V1::MerchantsController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
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
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(Merchant.find(merchant.id)) if merchant.update(merchant_params)
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
