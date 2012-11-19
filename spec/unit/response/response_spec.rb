require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#to_a' do
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

  describe '#status' do
    it "must return the status always as an integer" do
      subject.status = "foobar"
      subject.status.should eq(0)

      subject.status = 240.5
      subject.status.should eq(240)
    end

    it "must return 200, if no status code was set" do
      subject.status.should eq(200)
    end
  end

  describe '#header' do
    it "must return an empty hash, if no header was set" do
      subject.header.should eq({})
    end
  end

  describe '#body' do
    it "must return an empty array, if no body was set" do
      subject.body.should eq([])
    end
  end

end