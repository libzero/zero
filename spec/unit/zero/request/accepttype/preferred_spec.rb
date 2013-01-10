require 'spec_helper'

describe Zero::Request::AcceptType, '#preferred' do
  subject { Zero::Request::AcceptType }
  let(:html) { 'text/html' }
  let(:json) { 'application/json' }
  let(:foo)  { 'text/foo' }
  let(:lower_quality) { foo + ';q=0.5' }
  let(:default) { '*/*;q=0.1' }
  let(:option)  { [foo + ';b=23', html].join(',') }
  let(:simple_accept)  { [html, json].join(',') }
  let(:quality_accept) { [html, lower_quality, default].join(',') }
  let(:random_accept)  { [lower_quality, default, html].join(',') }
  let(:lower_accept)   { [lower_quality, default].join(',') }
  
  context 'without mapping' do
    it { subject.new(html).preferred.should                    == html  }
    it { subject.new(json).preferred.should                    == json  }
    it { subject.new(option).preferred.should                  == foo   }
    it { subject.new(simple_accept).preferred.should           == html  }
    it { subject.new(quality_accept).preferred.should          == html  }
    it { subject.new(random_accept).preferred.should           == html  }
    it { subject.new(lower_accept).preferred.should            == foo   }
    it { subject.new(nil).preferred.should                     == '*/*' }
    it { subject.new('').preferred.should                      == '*/*' }
    it { subject.new('text / html').preferred.should           == html  }
    it { subject.new("#{html};q=0.9,#{json}").preferred.should == json  }
  end

#  context 'with mapping' do
#    before :all do
#      Zero::Request::Accept.map = {'text/html' => 'html'}
#    end
#
#    after :all do
#      Zero::Request::Accept.map = {}
#    end
#
#    it { subject.new(html).preferred.should == 'html' }
#  end
end
