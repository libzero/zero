require 'spec_helper'

describe Zero::Renderer, '#render' do
  subject { Zero::Renderer.new(template_path) }
  let(:template_path) { 'foo' }
  let(:file_list) { ['./foo/welcome/index.html.erb'] }

  shared_examples_for 'the rendering' do
    before :each do
      subject.stub(:search_files).and_return(file_list)
      subject.stub(:template).and_return(Tilt[:erb].new {template} )
    end

    it "renders the template" do
      subject.render('welcome/index', 'text/html', binding).should eq(result)
    end
  end

  context 'a simple template' do
    let(:template) { 'success' }
    let(:binding) { Object.new }
    let(:result) { template }

    it_behaves_like 'the rendering'
  end

  context 'a complex template' do
    let(:template) { 'success <%= name %>' }
    let(:binding) { SpecTemplateContext.new('bar') }
    let(:result) { 'success bar' }

    it_behaves_like 'the rendering'
  end
end
