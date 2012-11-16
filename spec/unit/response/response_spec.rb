require 'spec_helper'

describe Zero::Response, '#finish' do
  subject { Zero::Response.new() }
  
  it "returns an array within status header and body" do
    subject.status = 200
    subject.header = {}
    subject.body   = []

    value = subject.to_a

    value.should be_an_instance_of(Array)
    value[0].should eq(200) # Status code
    value[1].should eq({})  # Headers
    value[2].should eq([])  # Body
  end

end