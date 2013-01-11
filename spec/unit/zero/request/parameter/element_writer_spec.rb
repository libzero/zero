require 'spec_helper'

describe Zero::Request::Parameter, '#[]=' do
  subject { described_class.new(env) }
  let(:env) { environment }

  let(:key)     { 'foo' }
  let(:wrong)   { 'wrong' }
  let(:correct) { 'correct' }

  it 'sets the key as a custom parameter' do
    subject[key] = correct
    expect(subject.custom[key]).to eq(correct)
  end

  it 'overwrites the key value' do
    subject[key] = wrong
    subject[key] = correct

    expect(subject.custom[key]).to eq(correct)
  end
end
