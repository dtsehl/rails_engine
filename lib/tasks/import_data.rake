require 'csv'

desc 'Import CSV data'
task import_data: [:environment] do
  InvoiceItem.delete_all
  Transaction.delete_all
  Invoice.delete_all
  Customer.delete_all
  Item.delete_all
  Merchant.delete_all

  customers = './db/data/customers.csv'
  @customer_count = 0
  invoice_items = './db/data/invoice_items.csv'
  @invoice_item_count = 0
  invoices = './db/data/invoices.csv'
  @invoice_count = 0
  items = './db/data/items.csv'
  @item_count = 0
  merchants = './db/data/merchants.csv'
  @merchant_count = 0
  transactions = './db/data/transactions.csv'
  @transaction_count = 0

  puts 'Creating customers...'

  CSV.foreach(customers, headers: true) do |row|
    Customer.create!(
      id: row[0],
      first_name: row[1],
      last_name: row[2],
      created_at: row[3],
      updated_at: row[4]
    )
    @customer_count += 1
  end
  puts "#{@customer_count} customers created!"
  puts 'Creating merchants...'

  CSV.foreach(merchants, headers: true) do |row|
    Merchant.create!(
      id: row[0],
      name: row[1],
      created_at: row[2],
      updated_at: row[3]
    )
    @merchant_count += 1
  end
  puts "#{@merchant_count} merchants created!"
  puts 'Creating invoices...'

  CSV.foreach(invoices, headers: true) do |row|
    Invoice.create!(
      id: row[0],
      customer_id: row[1],
      merchant_id: row[2],
      status: row[3],
      created_at: row[4],
      updated_at: row[5]
    )
    @invoice_count += 1
  end
  puts "#{@invoice_count} invoices created!"
  puts 'Creating items...'

  CSV.foreach(items, headers: true) do |row|
    Item.create!(
      id: row[0],
      name: row[1],
      description: row[2],
      unit_price: (row[3].to_f * 0.01).round(2),
      merchant_id: row[4],
      created_at: row[5],
      updated_at: row[6]
    )
    @item_count += 1
  end
  puts "#{@item_count} items created!"
  puts 'Creating transactions...'

  CSV.foreach(transactions, headers: true) do |row|
    Transaction.create!(
      id: row[0],
      invoice_id: row[1],
      credit_card_number: row[2],
      result: row[4],
      created_at: row[5],
      updated_at: row[6]
    )
    @transaction_count += 1
  end
  puts "#{@transaction_count} transactions created!"
  puts 'Creating invoice items...'

  CSV.foreach(invoice_items, headers: true) do |row|
    InvoiceItem.create!(
      id: row[0],
      item_id: row[1],
      invoice_id: row[2],
      quantity: row[3],
      unit_price: (row[4].to_f * 0.01).round(2),
      created_at: row[5],
      updated_at: row[6]
    )
    @invoice_item_count += 1
  end
  puts "#{@invoice_item_count} invoice items created!"
  puts 'Finished importing data!'

  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.reset_pk_sequence!(table)
  end
end
