require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe PageOne do

  it "should subclass HtmlFeed" do
    PageOne.ancestors.should include(HtmlFeed)
  end

end