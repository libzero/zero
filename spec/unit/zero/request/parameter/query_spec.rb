require 'spec_helper'

describe Zero::Request::Parameter, '#query' do
  subject { Zero::Request::Parameter.new(env) }

  context 'without parameters' do
    let(:env) { EnvGenerator.get('/foo') }
    its(:query) { should == {} }
  end

  context 'with a query string' do
    let(:env) { EnvGenerator.get('/foo?bar=baz') }
    its(:query) { should == {'bar' => 'baz'} }
  end

  context 'with a post body' do
    let(:env) { EnvGenerator.post('/foo', {:input => 'bar=baz'}) }
    its(:query) { should == {} }
  end

  context 'with special characters' do
    let(:env) { EnvGenerator.get('/foo?bar=foo%20bar') }
    its(:query) { should == {'bar' => 'foo bar'} }
  end
end
