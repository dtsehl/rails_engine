# Rails Engine

Rails Engine is the back end of a fictitious E-Commerce Application which exposes an API that the front end of the application, called [Rails Driver](https://github.com/turingschool-examples/rails_driver), will consume.

In Rails Engine, the API exposed allows the user the following functionality:
- CRUD (Create, Read, Update, Delete) a merchant and item through an API call.
- Return all items owned by a particular merchant, or the merchant that owns a particular item.
- Search for a merchant or item, or collection of merchants or items based on its attributes, which consist of one of the following:
  * Merchant
    * ID
    * Name
    * Created At (formatted like the following: 2012-03-27 14:53:59 UTC)
    * Updated At (formatted like the following: 2012-03-27 14:53:59 UTC)
  * Item
    * ID
    * Name
    * Description
    * Unit Price
    * Merchant ID (an item is owned by a merchant)
    * Created At (formatted like the following: 2012-03-27 14:53:59 UTC)
    * Updated At (formatted like the following: 2012-03-27 14:53:59 UTC)
- Make business intelligence queries which are the following:
  * The merchants with the most revenue, ranked by total revenue
  * The merchants with the most items sold, ranked by most items sold

## Versions

- Ruby 2.5.3
- Rails 5.2.4.3

## Installation

Please run the following commands in your terminal:

##### 1. Clone the repository to directory of choice

```
git clone git@github.com:dtsehl/rails_engine.git
```

##### 2. Install all gems

```
bundle install
```

##### 3. Create database

```
rails db:{create,migrate}
```

##### 4. Import CSV data to seed the database

```
bundle exec rake import_data
```

## Testing

To run the test suite inside of Rails Engine please run the following command:

```
bundle exec rspec
```

To get Rails Engine working with Rails Driver, open up a new terminal tab or window and repeat steps 1 & 2 of the above with the [Rails Driver](https://github.com/turingschool-examples/rails_driver) repository.

In your terminal tab or window with Rails Engine, type the command `rails server`. To shut down the server hold down the 'control' button on Mac and press the key 'c'.

Then, in your terminal tab or window with Rails Driver, type the command `bundle exec rspec` to run its test suite.

## Usage

With Rails Engine still running, open your API consumption tool of choice, such as Postman or just a regular Internet browser.

Then, begin your query to the API by using the following root URI on all queries:

```
http://localhost:3000/api/v1/
```

And append whatever request to the end that you desire. A non-exhaustive list of various endpoints that can be queried with a `GET` request are as follows:

- `merchants`
- `items`
- `items/:id`
- `items/find?name=<value>`
- `merchants/find_all?created_at=2012-03-27 14:53:59 UTC`
- `merchants/most_revenue?quantity=x` where `x` is the number of merchants that should be returned
- `merchants/most_items?quantity=x` where `x` is the number of merchants that should be returned

Please note that:
- Only `merchants` or `items` respond to a `POST` request
- Only `merchants/:id` or `items/:id` respond to a `PATCH` or `DELETE` request
