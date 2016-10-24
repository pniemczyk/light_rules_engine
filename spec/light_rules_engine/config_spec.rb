require 'spec_helper'

describe LightRulesEngine::Config do
  subject { described_class }

  it 'DEFAULT_CONSTS is defined' do
    expect(subject::DEFAULT_CONSTS).not_to be_nil
  end

  it 'DEFAULT_CONFIG is defined' do
    expect(subject::DEFAULT_CONFIG).not_to be_nil
  end
end

