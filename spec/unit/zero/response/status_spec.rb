# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

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
end
