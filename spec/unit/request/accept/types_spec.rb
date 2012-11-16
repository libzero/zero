require 'spec_helper'

describe Zero::Request::Accept, '#types' do
  subject { Zero::Request::Accept.new(env) }
  let(:media_types) { 'text/html' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT' => media_types}) }

  its(:types) { should be_an_instance_of(Zero::Request::AcceptType) }
end
