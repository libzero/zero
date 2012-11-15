require 'spec_helper'

describe Zero::Request::Server, '#port' do
  subject { Zero::Request::Server.new(env) }
  let(:env) { EnvGenerator.get('/foo', {'SERVER_PORT' => 80}) }
  its(:port) { should be(80) }
end
