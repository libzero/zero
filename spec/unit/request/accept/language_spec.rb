require 'spec_helper'

describe Zero::Request::Accept, '#language' do
  subject { Zero::Request::Accept.new(env) }
  let(:language) { 'en_US' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT_LANGUAGE' => language}) }

  it 'sets the language to the given value' do
    subject.language.preferred.should eq('en_US')
  end
end
