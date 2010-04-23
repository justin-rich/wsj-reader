require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MoneyInvesting do

  it "should subclass HtmlFeed" do
    MoneyInvesting.ancestors.should include(HtmlFeed)
  end
end
