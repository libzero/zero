require 'spec_helper'

describe Zero::Response::Cookie, '#add_crumb' do
  let(:cookie) { Zero::Response::Cookie.new }
  subject { cookie.add_crumb(key, value, options) }
  let(:options) { {
    :domain => domain,
    :path   => path,
    :expire => time,
    :flags  => flags
  } }
  let(:key)     { 'key' }
  let(:value)   { 'value' }
  let(:time)    { Time.new }
  let(:domain)  { 'libzero.org' }
  let(:path)    { '/admin' }
  let(:flags)   { [:secure, :http_only] }

  before :each do
    subject
  end

  it 'returns the header line' do
    expect(cookie.to_header).to eq(
      {'Set-Cookie' => "#{key}=#{value}; Expires=#{time.rfc2822};" +
                        " Path=#{path}; Domain=#{domain}; HttpOnly; Secure"}
    )
  end
end
