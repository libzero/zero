require 'spec_helper'

describe Zero::Request::Server, '#is_https?' do
  subject { Zero::Request::Server.new(env) }
  let(:hostname) { 'FooName' }

  context 'with http' do
    let(:env) { EnvGenerator.get('/foo', {'SERVER_NAME' => hostname}) }
    its(:is_https?) { should be(false) }
  end

  context 'with https' do
    let(:env) { EnvGenerator.get('/foo', {
      'SERVER_NAME' => hostname,
      'HTTPS' => 'on'
    }) }
    its(:is_https?) { should be(true) }
  end
end

