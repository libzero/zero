require 'spec_helper'

describe Zero::Request::AcceptType, '#each' do
  subject { Zero::Request::AcceptType.new(types) }
  let(:html) { 'text/html' }
  let(:json) { 'application/json' }
  let(:types) { [html, json].join(',') }

  specify { expect {|b| subject.each(&b) }.to yield_successive_args(html, json) }
end
