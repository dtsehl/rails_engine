class Merchant < ApplicationRecord
  extend Searchable

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.most_revenue(quantity)
    joins(invoice_items: :transactions)
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .where("transactions.result='success'")
      .group(:id)
      .order('total_revenue desc')
      .limit(quantity)
  end

  def self.most_items(quantity)
    joins(invoice_items: :transactions)
      .select('merchants.*, sum(invoice_items.quantity) as items_sold')
      .where("transactions.result='success'")
      .group(:id)
      .order('items_sold desc')
      .limit(quantity)
  end
end
