require 'spec_helper'

describe Zero::Request::Server, '#protocol' do
  subject { Zero::Request::Server.new(env) }
  let(:protocol) { 'HTTP FOO' }
  let(:env) { EnvGenerator.get('/foo', {'SERVER_PROTOCOL' => protocol}) }
  its(:protocol) { should be(protocol) }
end

