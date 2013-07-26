require 'spec_helper'

describe Zero::Request::Server, '#hostname' do
  subject { Zero::Request::Server.new(env) }
  let(:hostname) { 'FooName' }
  let(:env) { EnvGenerator.get('/foo', {'SERVER_NAME' => hostname}) }
  its(:hostname) { should be(hostname) }
end
