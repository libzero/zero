require 'spec_helper'

describe Zero::Request::Parameter, '#payload' do
  subject { Zero::Request::Parameter.new(env) }

  context "without parameters" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:payload) { should == {} }
  end

  context "with a query string" do
    let(:env) { EnvGenerator.get('/foo?bar=baz') }
    its(:payload) { should == {} }
  end

  context "with a post body" do
    let(:env) do
      EnvGenerator.post('/foo', {
        :input => 'bar=baz', 'CONTENT_TYPE' => 'multipart/form-data'
      })
    end
    its(:payload) { should == {'bar' => 'baz'} }
  end
end
