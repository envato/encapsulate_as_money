# EncapsulateAsMoney

[![Gem Version](https://badge.fury.io/rb/encapsulate_as_money.svg)](http://badge.fury.io/rb/encapsulate_as_money)
[![Build Status](https://github.com/envato/encapsulate_as_money/workflows/tests/badge.svg?branch=master)](https://github.com/envato/encapsulate_as_money/actions?query=branch%3Amaster+workflow%3Atests)

Want your model attribute to be a [Money](https://github.com/RubyMoney/money)
instance? EncapsulateAsMoney provides a simple way to get this done!

## Installation

Add this line to your application's Gemfile:

    gem 'encapsulate_as_money'

And then execute:

    $ bundle

## Usage

### Rails

Add the `encapsulate_as_money` method to the Active Record base class.

```ruby
ActiveRecord::Base.extend(EncapsulateAsMoney)
```

Now say you have the model:

```ruby
class MyModel < ActiveRecord::Base
  encapsulate_as_money :amount
end
```

Which is based on the database table:

```ruby
create_table "my_models" do |table|
  table.integer "amount"
end
```

Now we can create and save an instance like:

```ruby
MyModel.create!(amount: 5.dollars)
```

This will create a row as such:

| id | amount |
| --:| ------:|
|  1 |    500 |

Note the value is represented as cents.

Once persisted we can find the value like:

```ruby
MyModel.find_by_id(1).amount #=> 5.dollars
```

Note that it uses the default Money currency.

## Contributing

1. Fork it ( https://github.com/envato/encapsulate_as_money/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
