class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.search_single_by_string(params)
    find_by("lower(#{params.keys.first}) like ?", "%#{params.values.first.downcase}%")
  end

  def self.search_single_by_num(params)
    where("#{params.keys.first} = #{params.values.first}").first
  end

  def self.search_single_by_date(params)
    if params[:created_at].present?
      find_by_created_at(params[:created_at])
    else
      find_by_updated_at(params[:updated_at])
    end
  end

  def self.search_multiple_by_string(params)
    where("lower(#{params.keys.first}) like ?", "%#{params.values.first.downcase}%")
  end

  def self.search_multiple_by_num(params)
    where("#{params.keys.first} = #{params.values.first}")
  end

  def self.search_multiple_by_date(params)
    if params[:created_at].present?
      where(created_at: params[:created_at])
    else
      where(updated_at: params[:updated_at])
    end
  end
end
