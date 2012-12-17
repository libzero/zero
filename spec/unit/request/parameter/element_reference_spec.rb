require 'spec_helper'

describe Zero::Request::Parameter, '#[]' do
  subject { Zero::Request::Parameter.new(env) }

  context 'without parameters' do
    let(:env) { EnvGenerator.get('/foo') }

    it 'returns the custom parameter' do
      subject['foo'] = 'bar'
      expect(subject['foo']).to eq('bar')
    end
  end

  context 'with query parameters' do
    let(:env) { EnvGenerator.get('/foo?foo=bar') }

    it 'returns the query parameter' do
      expect(subject['foo']).to eq('bar')
    end

    it 'returns the custom parameter' do
      subject['foo'] = 'baz'
      expect(subject['foo']).to eq('baz')
    end
  end

  context 'with payload parameters' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'foo=bar', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end

    it 'returns the payload value' do
      expect(subject['foo']).to eq('bar')
    end

    it 'returns the custom parameter' do
      subject['foo'] = 'baz'
      expect(subject['foo']).to eq('baz')
    end
  end

  context 'with query and payload parameters' do
    let(:env) do
      EnvGenerator.post('/foo?foo=baz', {
        :input => 'foo=bar', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end

    it 'returns the payload parameter' do
      expect(subject['foo']).to eq('bar')
    end
  end
end
