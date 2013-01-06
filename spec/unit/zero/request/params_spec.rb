require 'spec_helper'

describe Zero::Request, '#params' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo?bar=baz') }

  its(:params) { should be_an_instance_of(Zero::Request::Parameter) }
end
