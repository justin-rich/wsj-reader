# require File.join( File.dirname(__FILE__), '..', "spec_helper" )
# 
# describe RssFeed do
# 
#   it "should subclass Feed" do
#     RssFeed.ancestors.should include(Feed)
#   end
# 
# end
# 
# describe RssFeed, "when passed get_source" do
#   
#   before(:all) do
#     @rss_feed = Factory.build(:rss_feed)
#     @http_resource = HttpResource.new('',true)    
#   end
#   
#   it "should set doc to an Hpricot::XML document" do
#     HttpResource.should_receive(:new).and_return(@http_resource)
#     @rss_feed.get_source
#     @rss_feed.doc.should be_a_kind_of(Hpricot::Doc)
#   end
#   
# end