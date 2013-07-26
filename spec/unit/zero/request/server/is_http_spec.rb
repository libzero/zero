require 'spec_helper'

describe Zero::Request::Server, '#is_http?' do
  subject { Zero::Request::Server.new(env) }
  let(:hostname) { 'FooName' }

  context 'with http' do
    let(:env) { EnvGenerator.get('/foo', {'SERVER_NAME' => hostname}) }
    its(:is_http?) { should be(true) }
  end

  context 'with https' do
    let(:env) { EnvGenerator.get('/foo', {
      'SERVER_NAME' => hostname,
      'HTTPS' => 'on'
    }) }
    its(:is_http?) { should be(false) }
  end
end

