require 'spec_helper'

describe Zero::Request::Parameter, '#[]' do
  let(:object) { described_class.new(env) }
  subject { object[key] }

  let(:query)  { '' }
  let(:post)   { {} }
  let(:custom) { {} }
  let(:env_get) { environment("/foo?#{query}", {:custom => custom})}
  let(:env_post) { environment("/foo?#{query}",{:payload => post, :custom => custom}) }

  let(:key)        { 'foo' }
  let(:value)      { 'correct' }
  let(:fake_value) { 'wrong' }

  shared_examples_for 'a parameter' do
    it { should eq(value) }
  end

  context 'with custom set key' do
    let(:env) { env_get }
    before do
      object[key] = value
    end

    it_behaves_like 'a parameter'
  end

  context 'with a custom set key from an environment' do
    let(:custom) { {key => value} }
    let(:env) { env_get }

    it_behaves_like 'a parameter'
  end

  context 'with query parameters' do
    let(:query) { "#{key}=#{value}" }
    let(:env) { env_get }

    it_behaves_like 'a parameter'
  end

  context 'with query and custom parameter' do
    let(:custom) { {key => value} }
    let(:query)  { "#{key}=#{fake_value}" }
    let(:env) { env_get }

    it_behaves_like 'a parameter'
  end

  context 'with query and post parameter' do
    let(:post)  { {key => value} }
    let(:query) { "#{key}=#{fake_value}" }
    let(:env)   { env_post }

    it_behaves_like 'a parameter'
  end

  context 'with query, post and custom parameter' do
    let(:custom) { {key => value} }
    let(:query)  { "#{key}=#{fake_value}" }
    let(:post)   { {key => fake_value} }
    let(:env)    { env_post }

    it_behaves_like 'a parameter'
  end

  context 'with no parameter set' do
    let(:env) { env_get }
    let(:value) { nil }

    it_behaves_like 'a parameter'
  end
end
