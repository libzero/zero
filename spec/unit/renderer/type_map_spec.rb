require 'spec_helper'

describe Zero::Renderer, '.type_map' do
  subject { Zero::Renderer }
  let(:mapping) {{ 'test/foo' => 'foo' }}
  it "saves the map" do
    subject.type_map = mapping
    subject.type_map.should be(mapping)
  end
end
