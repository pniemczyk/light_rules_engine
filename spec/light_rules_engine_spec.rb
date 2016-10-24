require 'spec_helper'

class Booking
  def initialize(number, date, name, items = {}, elems = [], numbers = [])
    @date = date
    @number = number
    @name = name
    @items = items
    @elems = elems
    @numbers = numbers
  end

  attr_reader :date, :number, :name, :items, :elems, :numbers
end

class Container
  def initialize(booking)
    @booking = booking
  end

  attr_reader :booking
end

describe LightRulesEngine do
  it 'has a version number' do
    expect(LightRulesEngine::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end

  # $operator
  # @value
  # %const
  #
  let(:conditions_secound) do
    {
      kind: :operator,
      type: :all,
      values: [
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.number' },
            { kind: :value, type: :integer, value: 1 }
          ]
        },
        {
          kind: :operator,
          type: :gt,
          values: [
            { kind: :data, type: 'booking.number' },
            { kind: :value, type: :integer, value: 0 }
          ]
        },
        {
          kind: :operator,
          type: :lt,
          values: [
            { kind: :data, type: 'booking.number' },
            { kind: :value, type: :integer, value: 2 }
          ]
        },
        {
          kind: :operator,
          type: :range,
          values: [
            { kind: :value, type: :integer, value: 0 },
            { kind: :value, type: :integer, value: 2 },
            { kind: :data, type: 'booking.number' }
          ]
        },
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.items["a"].id' },
            { kind: :value, type: :integer, value: 1 }
          ]
        },
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.elems[0].name' },
            { kind: :value, type: :string, value: 'a' }
          ]
        },
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.elems.last.name' },
            { kind: :value, type: :string, value: 'a' }
          ]
        },
        {
          kind: :operator,
          type: :eq,
          values: [
            { kind: :data, type: 'booking.numbers.max' },
            { kind: :value, type: :integer, value: 300 }
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
                { kind: :const, type: 'THE_NUMBER' },
                { kind: :value, type: :integer, value: 3 }
              ]
            },
            {
              kind: :operator,
              type: :eq,
              values: [
                { kind: :data, type: 'booking.name' },
                { kind: :value, type: :string, value: 'test' }
              ]
            }
          ]
        }
      ]
    }
  end

  let(:conditions_simple) do
    {
      kind: :operator,
      type: :eq,
      values: [
        { kind: :data, type: 'booking.number' },
        { kind: :value, type: :integer, value: 1 }
      ]
    }
  end

  let(:conditions) do
    {
      '$_all' => [
        { '$_eq' => ['@_booking.number', 1] },
        { '$_gt' => ['@_booking.number', 0] },
        { '$_lt' => ['@_booking.number', 2] },
        {
          '$any' => [
            { '$_eq' => ['%_THE_NUMBER', 1] },
            { '$_fluent_dates_eq' => ['$_booking.date', 'CHRISTMAS'] },
            { '$_eq' => ['$_booking.name', 'test'] }
          ]
        }
      ]
    }
  end

  let(:shema) do
    {
      booking: {
        kind: :object,
        props: {
          number: { kind: :integer },
          date: { kind: :date_time },
          name: { kind: :string }
        }
      }
    }
  end

  let(:container) do
    Container.new(Booking.new(1, Time.now, 'test', { 'a' => double('Test', id: 1) }, [double('ttt', name: 'a')], [1, 300, -1]))
  end

  it 'process' do
    processor = LightRulesEngine::Processor.new(conditions: conditions_secound, data_container: container)
    expect(processor.applable?).to eq(true)
  end
end
