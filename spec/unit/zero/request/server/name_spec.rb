require 'spec_helper'

describe Zero::Request::Server, '#name' do
  subject { Zero::Request::Server.new(env) }
  let(:hostname) { 'FooName' }
  let(:port) { '80' }
  let(:protocol) { 'http' }
  let(:result) { 'http://FooName:80' }

  let(:env) { EnvGenerator.get('/foo', {
    'SERVER_NAME' => hostname,
    'SERVER_PROTOCOL' => protocol,
    'SERVER_PORT' => port
  }) }

  it "generates a name" do
    expect(subject.name).to match(result)
  end
end

