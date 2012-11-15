require 'spec_helper'

describe Zero::Request::Server, '#software' do
  subject { Zero::Request::Server.new(env) }
  let(:software) { 'SpecWare Server' }
  let(:env) { EnvGenerator.get('/foo', {'SERVER_SOFTWARE' => software}) }
  its(:software) { should be(software) }
end

