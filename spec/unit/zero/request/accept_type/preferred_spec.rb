require 'spec_helper'

describe Zero::Request::AcceptType, '#preferred' do
  subject { Zero::Request::AcceptType.new(type_string).preferred }
  let(:type_string) { types.join(',') }

  let(:html) { 'text/html' }
  let(:json) { 'application/json' }
  let(:foo)  { 'text/foo' }
  let(:default) { '*/*' }
  let(:default_q) { '*/*;q=0.1' }

  shared_examples_for 'a preferred type' do
    it { should eq(result) }
  end

  context 'with a single type' do
    let(:types) { [html] }
    let(:result) { html }

    it_behaves_like 'a preferred type'
  end

  context 'with two types' do
    let(:types) { [html, json] }
    let(:result) { html }

    it_behaves_like 'a preferred type'
  end

  context 'with multiple types and quality identifier' do
    let(:types) { ["#{json};q=0.5", html, default_q] }
    let(:result) { html }

    it_behaves_like 'a preferred type'
  end

  # this is for mutant - mutant modifies the default quality from 0 to 1
  # the 0.9 gets translated to a quality of 1, so that the ordering gets
  # different than before and that is why we have two tests here
  context 'with quality ordering' do
    let(:types) { ["#{json};q=0.9", html, default_q] } 
    let(:result) { html }

    it_behaves_like 'a preferred type'
  end

  context 'with different kinds of options' do
    let(:types) { ["#{json};b=foo", html] }
    let(:result) { json }

    it_behaves_like 'a preferred type'
  end

  context 'with an empty types' do
    let(:types) { [] }
    let(:result) { default }

    it_behaves_like 'a preferred type'
  end

  context 'with whitespaces' do
    let(:types) { ['text / html'] }
    let(:result) { html }

    it_behaves_like 'a preferred type'
  end

  context 'with nil' do
    subject { Zero::Request::AcceptType.new(nil).preferred }
    let(:result) { default }

    it_behaves_like 'a preferred type'
  end
end
