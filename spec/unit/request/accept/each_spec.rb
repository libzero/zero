require 'spec_helper'

describe Zero::Request::Accept, '#each' do
  subject { Zero::Request::Accept.new(types) }
  let(:html) { 'text/html' }
  let(:json) { 'application/json' }
  let(:types) { [html, json].join(',') }

  specify { expect {|b| subject.each(&b) }.to yield_successive_args(html, json) }
end
