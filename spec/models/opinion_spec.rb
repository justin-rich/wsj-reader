require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Opinion do

  it "should subclass HtmlFeed" do
    Opinion.ancestors.should include(HtmlFeed)
  end
  
end