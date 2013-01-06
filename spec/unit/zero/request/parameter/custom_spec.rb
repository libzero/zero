require 'spec_helper'

describe Zero::Request::Parameter, '#custom' do
  subject { Zero::Request::Parameter.new(env) }
  let(:env) { EnvGenerator.get('/foo') }

  it 'returns a set custom parameter' do
    subject['foo'] = 'bar'
    expect(subject.custom['foo']).to eq('bar')
  end

  it 'returns the latest set value' do
    subject['foo'] = 'first'
    subject['foo'] = 'latest'

    expect(subject.custom['foo']).to eq('latest')
  end

  it 'is empty if no custom parameter is set' do
    expect(subject.custom).to eq({})
    expect(env['zero.params.custom']).to eq({})
  end
end
