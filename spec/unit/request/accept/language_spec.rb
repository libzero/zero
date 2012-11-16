require 'spec_helper'

describe Zero::Request::Accept, '#language' do
  subject { Zero::Request::Accept.new(env) }
  let(:language) { 'en_US' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT_LANGUAGE' => language}) }

  its(:language) { should be_an_instance_of(Zero::Request::AcceptType) }
end
