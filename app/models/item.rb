class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def self.search_by_string(params)
    find_by("lower(#{params.keys.first}) like ?", "%#{params.values.first.downcase}%")
  end

  def self.search_by_num(params)
    where("#{params.keys.first} = #{params.values.first}").first
  end

  def self.search_by_date(params)
    if params[:created_at].present?
      find_by_created_at(params[:created_at])
    else
      find_by_updated_at(params[:updated_at])
    end
  end
end
