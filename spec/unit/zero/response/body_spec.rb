# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#body' do
    it "must return an empty array, if no body was set" do
      subject.body.should eq([])
    end
  end

  describe '#body=' do
    let(:string) { "new body" }
    let(:array)  { ["new body"] }
    let(:object_with_each) { {:a => "b" } }
    let(:invalid_object)   { 12345 }

    it "creates an array body for strings" do
      subject.body = string
      expect(subject.body).to eq(array)
    end

    it "sets the body to the array" do
      subject.body = array
      expect(subject.body).to be(array)
    end

    it "sets an object as string when responding to #each" do
      subject.body = object_with_each
      expect(subject.body).to be(object_with_each)
    end

    it "raises an argument error for invalid input" do
      expect{subject.body = invalid_object}.to raise_error(
                                                  ArgumentError, /invalid body/)
    end
  end
end
