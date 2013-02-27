require 'spec_helper'

describe Zero::Renderer, '#templates' do
  let(:object) { described_class.new(template_path, types) }
  subject { object.templates }
  
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:types) { {'html' => ['text/html']} }

  it 'loads the template tree' do
    expect(subject).to be_kind_of(Zero::Renderer::TemplateFinder)
  end
end
