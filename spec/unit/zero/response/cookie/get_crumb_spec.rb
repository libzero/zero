require 'spec_helper'

describe Zero::Response::Cookie, '#add_crumb' do
  let(:cookie) { Zero::Response::Cookie.new }
  subject { cookie.add_crumb(key, value, options) }
  let(:options) { {} }
  let(:key)     { 'key' }
  let(:value)   { 'value' }

  before :each do
    subject
  end

  it 'returns the crumb when the crumb exists' do
    expect(cookie.get_crumb(key).key).to be(key)
  end

  it 'returns nil for the wrong key' do
    expect(cookie.get_crumb('wrong key')).to be(nil)
  end
end
