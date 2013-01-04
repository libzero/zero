require 'spec_helper'

describe Zero::Request::Accept, '#encoding' do
  subject { Zero::Request::Accept.new(env) }
  let(:encoding) { 'en_US' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT_ENCODING' => encoding}) }

  it 'sets the encoding to the given value' do
    subject.encoding.preferred.should eq('en_US')
  end
end
