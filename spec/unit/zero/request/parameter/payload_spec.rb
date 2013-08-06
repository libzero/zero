require 'spec_helper'

describe Zero::Request::Parameter, '#payload' do
  subject { Zero::Request::Parameter.new(env) }

  context 'without parameters' do
    let(:env) { EnvGenerator.get('/foo') }
    its(:payload) { should == {} }
  end

  context 'with a query string' do
    let(:env) { EnvGenerator.get('/foo?bar=baz') }
    its(:payload) { should == {} }
  end

  context 'with a post body' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'bar=baz', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end
    its(:payload) { should == {'bar' => 'baz'} }
  end

  context 'with special characters' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'bar=foo%20bar', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end
    its(:payload) { should == {'bar' => 'foo bar'} }
  end

  context 'with multiple parameters' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'bar=foo&foo=bar', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end
    its(:payload) { should == {'foo' => 'bar', 'bar' => 'foo'} }
  end

  context 'with a list' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'bar[]=foo&bar[]=bar',
        'CONTENT_TYPE' => 'multipart/form-data'
      })
    end
    its(:payload) { should == {'bar[]' => ['foo', 'bar']} }
  end

  # TODO behaves like this, but is this really good like this?
  context 'with a post body and content type application/json' do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => '"foobar"', 'CONTENT_TYPE' => 'application/json'
      })
    end
    its(:payload) { should == {} }
  end
end
