require 'spec_helper'

describe Zero::Request::Client, '#hostname' do
  subject { Zero::Request::Client.new(env) }
  let(:hostname) { 'foo.bar' }
  let(:env) { {'REMOTE_HOST' => hostname} }

  its(:hostname) { should == hostname }
end
