require 'spec_helper'

describe LightRulesEngine::ConditionsApplicableChecker do
  let(:conditions) do
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
                { kind: :const, type: 'RULE_ENGINE' },
                { kind: :value, type: :string, value: 'LightRulesEngine' }
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

  let(:booking_number) { 1 }
  let(:data_container) { @data_container }
  before do
    @data_container = double(
      'data_container',
      booking: double(
        'booking',
        number: booking_number,
        time: Time.now,
        name: 'test',
        items: { 'a' => double('Test', id: 1) },
        elems: [double('ttt', name: 'a')],
        numbers: [1, 300, -1]
      )
    )
  end
  subject { described_class.new(data_container: data_container, conditions: conditions) }

  context '#applable?' do
    it 'returns true when conditions pass' do
      expect(subject.applable?).to eq(true)
    end

    context 'when conditions not pass' do
      let(:booking_number) { 0 }

      it 'returns false' do
        expect(subject.applable?).to eq(false)
      end
    end
  end
end
