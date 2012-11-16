require 'spec_helper'

describe Zero::Request::Accept, '#encoding' do
  subject { Zero::Request::Accept.new(env) }
  let(:encoding) { 'en_US' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT_ENCODING' => encoding}) }

  its(:encoding) { should be_an_instance_of(Zero::Request::AcceptType) }
end
