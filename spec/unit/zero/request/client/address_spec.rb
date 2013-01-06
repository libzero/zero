require 'spec_helper'

describe Zero::Request::Client, '#address' do
  subject { Zero::Request::Client.new(env) }
  let(:address) { '127.0.0.1' }
  let(:env) { {'REMOTE_ADDR' => address} }

  its(:address) { should == address }
end
