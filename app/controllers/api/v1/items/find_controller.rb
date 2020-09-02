class Api::V1::Items::FindController < ApplicationController
  def show
    item = if item_params_string.present?
             Item.search_single_by_string(item_params_string)
           elsif item_params_num.present?
             Item.search_single_by_num(item_params_num)
           else
             Item.search_single_by_date(item_params_date)
           end
    if item.nil?
      record_not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def index
    items = if item_params_string.present?
              Item.search_multiple_by_string(item_params_string)
            elsif item_params_num.present?
              Item.search_multiple_by_num(item_params_num)
            else
              Item.search_multiple_by_date(item_params_date)
            end
    if items.empty?
      record_not_found
    else
      render json: ItemSerializer.new(items)
    end
  end

  private

  def item_params_string
    params.permit(:name, :description)
  end

  def item_params_num
    params.permit(:id, :unit_price, :merchant_id)
  end

  def item_params_date
    params.permit(:created_at, :updated_at)
  end
end
