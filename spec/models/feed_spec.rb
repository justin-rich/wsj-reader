require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Feed, 'when passed get_new_articles' do
  before(:each) do
    @feed = Factory.build(:feed)
  end
  
  it "should raise an unimplemeented error" do
    lambda {@feed.get_new_articles}.should raise_error
  end
end

describe Feed, 'when passed get_source' do
  before(:each) do
    @feed = Factory.build(:feed)
  end
  
  it "should raise an unimplemeented error" do
    lambda {@feed.get_source}.should raise_error    
  end
end