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

  context 'with no argument' do
    it 'adds a new crumb' do
      expect(cookie.get_crumb(key).key).to be(key)
    end
  end

  context 'with flags' do
    let(:options) { {:flags => [:secure, :http_only]} }

    it 'adds a crumb with secure header' do
      expect(cookie.get_crumb(key).secure).to be(true)
    end

    it 'adds a crumb with http_only header' do
      expect(cookie.get_crumb(key).http_only).to be(true)
    end
  end

  context 'with expire' do
    let(:time) { Time.now }
    let(:options) { {:expire => time} }

    it 'adds a crumb with expire header' do
      expect(cookie.get_crumb(key).expire).to be(time)
    end
  end

  context 'with domain and path' do
    let(:domain) { 'libzero.org' }
    let(:path)   { '/admin' }
    let(:options) { {:domain => domain, :path => path} }

    it 'adds a crumb with domain header' do
      expect(cookie.get_crumb(key).domain).to be(domain)
    end

    it 'adds a crumb with path header' do
      expect(cookie.get_crumb(key).path).to be(path)
    end
  end
end
