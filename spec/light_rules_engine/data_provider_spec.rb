require 'spec_helper'

describe LightRulesEngine::DataProvider do
  subject { described_class.new(data) }

  context 'chain methods' do
    let(:data) do
      double('object', first: double('object', nested: double('object', last: 1)))
    end
    it 'returns correct value' do
      expect(subject.value_for('first.nested.last')).to eq(1)
    end

    it 'returns nil if chain do not exists' do
      expect(subject.value_for('abba.nested.first')).to be_nil
    end
  end

  context 'array' do
    let(:data) do
      double('object', arr: [double('object', last: 5)])
    end

    it 'returns element of array' do
      expect(subject.value_for('arr[0].last')).to eq(5)
    end

    it 'returns nil when element of array do not exists' do
      expect(subject.value_for('arr[2].last')).to be_nil
    end
  end

  context 'hash' do
    let(:data) do
      double('object', hash: { test: double('object', number: 11), 'koala' => 3 })
    end

    it 'returns hash symbolize key value' do
      expect(subject.value_for('hash[:test].number')).to eq(11)
    end

    it 'returns hash stingify key value' do
      expect(subject.value_for('hash["koala"]')).to eq(3)
    end

    it 'returns nil when hash key is not found' do
      expect(subject.value_for('hash[:b].load')).to be_nil
    end
  end

  context 'method call' do
    let(:data) do
      double('object', arr: [1, 1, 2, 2, 2])
    end

    it 'returns correct value' do
      expect(subject.value_for('arr.count(2)')).to eq(3)
    end
  end

  context 'raise ReturningValueError' do
    let(:data) do
      double('object', arr: [1])
    end

    it 'when syntax is unknown' do
      expect { subject.value_for('arr.map(&:something)') }.to raise_error(
        LightRulesEngine::DataProvider::ReturningValueError
      )
    end
  end
end
