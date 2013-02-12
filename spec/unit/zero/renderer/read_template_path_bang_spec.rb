require 'spec_helper'

describe Zero::Renderer, '#read_template_path!' do
  subject { Zero::Renderer.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map)      { {'html' => ['text/html']} }
  let(:result) { {
    'text/html' => template_path + 'index.html.erb',
    'json'      => template_path + 'index.json.erb'
    } }

  it "loads the templates" do
    subject.read_template_path!
    expect(subject.templates['index']).to eq(result)
  end
end
