require 'spec_helper'

describe Zero::Request::Parameter, '#cookie' do
  subject { Zero::Request::Parameter.new(env) }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_COOKIE' => cookie}) }

  context 'without parameters' do
    let(:env) { EnvGenerator.get('/foo') }
    its(:cookie) { should == {} }
  end

  context 'with a single key value pair' do
    let(:cookie) { 'foo=bar' }
    its(:cookie) { should == {'foo' => 'bar'} }
  end

  context 'with multiple key value pairs' do
    let(:cookie) { 'foo=bar; baz=foobar' }
    its(:cookie) { should == {'foo' => 'bar', 'baz' => 'foobar'} }
  end
end
