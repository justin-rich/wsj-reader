require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe HtmlFeed, "when passed get_source" do
  
  before(:all) do
    @html_feed = HtmlFeed.new(Factory.attributes_for(:feed))
    @http_resource = HttpResource.new('',true)        
    HttpResource.should_receive(:new).and_return(@http_resource)
    @html_feed.get_source            
  end
  
  it "should set the doc variable" do
    @html_feed.doc.should_not be_nil
  end

  it "should set the doc variable to a NokoGiri::HTML::Document" do
    @html_feed.doc.should be_a_kind_of(Nokogiri::HTML::Document)    
  end
  
end