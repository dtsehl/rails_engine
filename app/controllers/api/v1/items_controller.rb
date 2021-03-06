class Api::V1::ItemsController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(Item.find(item.id))
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(Item.find(item.id))
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
