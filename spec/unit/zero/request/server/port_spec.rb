require 'spec_helper'

describe Zero::Request::Server, '#port' do
  subject { Zero::Request::Server.new(env) }

  context 'sets the port to the given value' do
    let(:env) { EnvGenerator.get('/foo', {'SERVER_PORT' => 80}) }
    its(:port) { should be(80) }
  end

  context 'casts also the port to an integer, while setting it' do
    let(:env) { EnvGenerator.get('/foo', {'SERVER_PORT' => '80'}) }
    its(:port) { should be(80) }
  end
end
