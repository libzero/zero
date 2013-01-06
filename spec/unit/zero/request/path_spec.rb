require 'spec_helper'

describe Zero::Request, '#path' do
  subject { Zero::Request.new(env) }
  let(:path) { '/foo' }
  let(:env) { EnvGenerator.get(path) }

  its(:path) { should == path }
end
