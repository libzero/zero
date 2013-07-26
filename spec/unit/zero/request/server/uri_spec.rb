require 'spec_helper'

describe Zero::Request::Server, '#uri' do
  subject { Zero::Request::Server.new(env) }
  let(:hostname) { 'FooName' }
  let(:port) { '80' }
  let(:protocol) { 'http' }
  let(:env) { EnvGenerator.get('/foo', {
    'SERVER_NAME' => hostname,
    'SERVER_PORT' => port
  }) }

  context 'with standard port' do
    let(:result) { "#{protocol}://#{hostname}" }
    its(:uri) { should eq(result) }
  end

  context 'with different port' do
    let(:port) { '9292' }
    let(:result) { "#{protocol}://#{hostname}:#{port}" }
    its(:uri) { should eq(result) }
  end
end
