desc "Import CSV data"
task :import_data do
  require 'csv'
  customers = CSV.read('db/data/customers.csv')
  invoice_items = CSV.read('db/data/invoice_items.csv')
  invoices = CSV.read('db/data/invoices.csv')
  items = CSV.read('db/data/items.csv')
  merchants = CSV.read('db/data/merchants.csv')
  transactions = CSV.read('db/data/transactions.csv')
end