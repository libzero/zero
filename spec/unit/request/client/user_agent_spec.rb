require 'spec_helper'

describe Zero::Request::Client, '#user_agent' do
  subject { Zero::Request::Client.new(env) }
  let(:user_agent) { 'Mozilla (dummy agent)' }
  let(:env) { {'HTTP_USER_AGENT' => user_agent} }

  its(:user_agent) { should == user_agent }
end
