# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#body' do
    it "must return an empty array, if no body was set" do
      subject.body.should eq([])
    end
  end
end
