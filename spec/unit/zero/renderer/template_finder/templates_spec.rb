require 'spec_helper'

describe Zero::Renderer::TemplateFinder, '#initialize' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'foo/' }
  let(:file_list) { ['foo/welcome/index.html.erb'] }

  before :each do
    Dir.stub(:[]) do |arg|
      if arg == 'foo/**/*.*'
        file_list
      else
        []
      end
    end
  end

  shared_examples_for 'a template loader' do
    it 'creates a template tree' do
      subject.templates['welcome/index'].should eq(result)
    end
  end

  context 'without mapping' do
    let(:type_map) { {} }
    let(:result) { { 'html' => 'foo/welcome/index.html.erb' } }

    it_behaves_like 'a template loader'
  end

  context 'with a single mapping' do
    let(:type_map) { {'html' => 'text/html' } }
    let(:result) { { 'text/html' => 'foo/welcome/index.html.erb' } }

    it_behaves_like 'a template loader'
  end

  context 'with multiple mappings' do
    let(:type_map) { {'html' => ['text/html', 'text/xml'] } }
    let(:result) { {
      'text/html' => 'foo/welcome/index.html.erb',
      'text/xml'  => 'foo/welcome/index.html.erb'
    } }

    it_behaves_like 'a template loader'
  end

  context 'with default template' do
    let(:file_list) {['foo/welcome/index.erb']}
    let(:type_map) { {'default' => ['text/html', 'text/xml'] } }
    let(:result) { {
      'text/html' => 'foo/welcome/index.erb',
      'text/xml'  => 'foo/welcome/index.erb'
    } }

    it_behaves_like 'a template loader'
  end
end
