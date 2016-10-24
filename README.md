# LightRulesEngine

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/light_rules_engine`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'light_rules_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install light_rules_engine

## Usage

### Concept of light rule engine

When we need to have some kind of dynamic rules which we want to apply based on some conditions this can be a solution.

- Rule it is place holder for business decisions and conditions when we can apply them

So Rule:

```
    class BookingRule < LightRulesEngine::BaseRule
    end

    booking = double('booking', kind: 'Hotel', room: 'single', pax: 4, items: { bed: 'double', see_view: true, windows_count: 4 })

    data_container = DataContainerBuilder.build(booking, name: :booking)
    conditions     ={
      kind: :operator,
      type: :all,
      values: [
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.kind' },
            { kind: :value, type: :string, value: 'Hotel'}
          ]
        },
        {
          kind: :operator,
          type: :gt,
          values: [
            { kind: :data, type: 'booking.pax' },
            { kind: :value, type: :integer, value: 2 }
          ]
        },   
        {
          kind: :operator,
          type: :any,
          values: [
            {
              kind: :operator,
              type: :eq,
              values: [
                { kind: :const, type: 'DOUBLE_BED' },
                { kind: :data, type: 'booking.items[:bed]' }
              ]
            },
            {
              kind: :operator,
              type: :range,
              values: [
                { kind: :value, type: 'integer', value: 3 },
                { kind: :value, type: 'integer', value: 12 },
                { kind: :data, type: 'booking.items[:windows_count]' }
              ]
            }
          ]
        }
      ]
    }
    rule = BookingRule.new(source: business_source_logic, conditions: conditions)
    
    # true / false
    LightRulesEngine.applicable_conditions?(data_container, conditions)
    
    # list of rules which are valid
    LightRulesEngine.rules_applicable?(data_container, rule)
```

### Configuration

```
DEFAULT_CONFIG = {
  data_provider_class: LightRulesEngine::DataProvider,
  operators_namespace: LightRulesEngine::Operators,
  operation_context_class: LightRulesEngine::OperatorContxt,
  value_resolver_class: LightRulesEngine::ValueResolver,
  consts: DEFAULT_CONSTS
}.freeze
```

update of configuration is like:

```
class MyOperators
  include LightRulesEngine::Operators # to have already defined operators
  class DateEq
    def self.result(*args)
      first_date, last_date = args
      return movable_date(first_date, last_date) if keyword?(first_date)
      return movable_date(last_date, first_date) if keyword?(last_date)
      first_date == last_date
    end

    def self.movable_date(date_keyword, date_to_compare)
      ...
    end
  end
end

LightRulesEngine.setup_config(operators_namespace: MyOperators)

conditions = {
  kind: :operator,
  type: :eq,
  values: [
    { kind: :value, type: 'EASTER_MONDAY' },
    { kind: :data, type: 'booking.date' }
  ]
}
rule           = BookingRule.new(source: business_source_logic, conditions: conditions)
data_container = DataContainerBuilder.build(booking, name: :booking)

# list of rules which are valid
LightRulesEngine.rules_applicable?(data_container, rule)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/light_rules_engine. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

