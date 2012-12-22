# encoding: UTF-8

require 'spec_helper'

describe URI, '#parse_query_string' do

  it 'seperates parameter into an array' do
    result = URI::parse_query_string("foo=bar&bar=foo")

    result.should eq([['foo', 'bar'], ['bar', 'foo']])
  end

  it 'can handle more than two equal parameter names' do
    result = URI::parse_query_string("foo=bar1&foo=bar2")

    result.should eq([['foo', 'bar1'], ['foo', 'bar2']])
  end

  it 'can handle whitespaces in query string' do
    result = URI::parse_query_string("foo=bar&bar=bar%20foo")

    result.should eq([['foo', 'bar'], ['bar', 'bar foo']])
  end

  it 'accepts semi-colons as seperators' do
    result = URI::parse_query_string("foo=bar;bar=foo")

    result.should eq([['foo', 'bar'], ['bar', 'foo']])
  end

  it 'seperates & and ; mixed queries properly' do
    result = URI::parse_query_string("foo=bar&bar=foo;baz=foo")

    result.should eq([['foo', 'bar'], ['bar', 'foo'], ['baz', 'foo']])
  end

  it 'does not accept only a normal string as query string' do
    expect{
      result = URI::parse_query_string("foo")

      # does not work, probably should?
      #result.should eq([['foo', '']])
    }.to raise_error(
      ArgumentError,
      "invalid data of application/x-www-form-urlencoded (foo)"
    )
  end

  it 'accepts empty values' do
      result = URI::parse_query_string("foo=bar&bar=&baz=foo")

      result.should eq([['foo', 'bar'], ['bar', ''], ['baz', 'foo']])
  end

  it 'understands plus as whitespace' do
    result = URI::parse_query_string("foo=bar&bar=bar+foo")

    result.should eq([['foo', 'bar'], ['bar', 'bar foo']])
  end

  it 'does not accept whitespaces in query string' do
    result = URI::parse_query_string("foo=bar&bar=bar foo&baz=foo")

    # Works, it probably shouldn't?
    result.should eq([['foo', 'bar'], ['bar', 'bar foo'], ['baz', 'foo']])
  end

  it 'can handle non ascii letters in query string' do
    result = URI::parse_query_string("foo=bär&bar=föö")

    # Works, but it maybe shouldn't?
    result.should eq([['foo', 'bär'], ['bar', 'föö']])
  end

  it 'can handle escaped non ascii letters in query string' do
    result = URI::parse_query_string("foo=b%C3%A4r&bar=f%C3%B6%C3%B6")

    result.should eq([['foo', 'bär'], ['bar', 'föö']])
  end

  it 'accepts - in query string' do
    result = URI::parse_query_string("foo-bar=bar&bar=foo-bar")

    result.should eq([['foo-bar', 'bar'], ['bar', 'foo-bar']])
  end

  it 'accepts . in query string' do
    result = URI::parse_query_string("foo.bar=bar&bar=foo.bar")

    result.should eq([['foo.bar', 'bar'], ['bar', 'foo.bar']])
  end

  it 'accepts ~ in query string' do
    result = URI::parse_query_string("foo~bar=bar&bar=foo~bar")

    result.should eq([['foo~bar', 'bar'], ['bar', 'foo~bar']])
  end

  it 'accepts _ in query string' do
    result = URI::parse_query_string("foo_bar=bar&bar=foo_bar")

    result.should eq([['foo_bar', 'bar'], ['bar', 'foo_bar']])
  end

  it 'handles [ ] in query string' do
    result = URI::parse_query_string("foo[]=foo&foo[]=bar")

    result.should eq([['foo[]', 'foo'], ['foo[]', 'bar']])
  end

end
