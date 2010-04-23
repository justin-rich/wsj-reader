require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe HttpResource, 'when instantiated' do
  
  before(:all) do
    @resource = HttpResource.new(Factory.attributes_for(:article)[:url], 10)
  end
  
  it "should set a cookie in 'config/wsj/cookies.txt' if the file does not already exist" do    
    `rm #{Merb.root}/config/wsj/cookies.txt`    
    @resource.login
    cookie = File.open(Merb.root + '/config/wsj/cookies.txt').read
    cookie.should match("Cookie")
  end
  
  it "should set the URL from the given URL" do
    @resource.url.should == Factory.attributes_for(:article)[:url]
  end
  
  it "should download the URL and set contents" do    
    @resource.contents.should_not == nil    
  end
  
end
