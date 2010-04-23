# require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
# 
# given "a rss_feed exists" do
#   RssFeed.all.destroy!
#   request(resource(:rss_feeds), :method => "POST", 
#     :params => { :rss_feed => { :id => nil }})
# end
# 
# describe "resource(:rss_feeds)" do
#   describe "GET" do
#     
#     before(:each) do
#       @response = request(resource(:rss_feeds))
#     end
#     
#     it "responds successfully" do
#       @response.should be_successful
#     end
# 
#     it "contains a list of rss_feeds" do
#       pending
#       @response.should have_xpath("//ul")
#     end
#     
#   end
#   
#   describe "GET", :given => "a rss_feed exists" do
#     before(:each) do
#       @response = request(resource(:rss_feeds))
#     end
#     
#     it "has a list of rss_feeds" do
#       pending
#       @response.should have_xpath("//ul/li")
#     end
#   end
#   
#   describe "a successful POST" do
#     before(:each) do
#       RssFeed.all.destroy!
#       @response = request(resource(:rss_feeds), :method => "POST", 
#         :params => { :rss_feed => { :id => nil }})
#     end
#     
#     it "redirects to resource(:rss_feeds)" do
#       @response.should redirect_to(resource(RssFeed.first), :message => {:notice => "rss_feed was successfully created"})
#     end
#     
#   end
# end
# 
# describe "resource(@rss_feed)" do 
#   describe "a successful DELETE", :given => "a rss_feed exists" do
#      before(:each) do
#        @response = request(resource(RssFeed.first), :method => "DELETE")
#      end
# 
#      it "should redirect to the index action" do
#        @response.should redirect_to(resource(:rss_feeds))
#      end
# 
#    end
# end
# 
# describe "resource(:rss_feeds, :new)" do
#   before(:each) do
#     @response = request(resource(:rss_feeds, :new))
#   end
#   
#   it "responds successfully" do
#     @response.should be_successful
#   end
# end
# 
# describe "resource(@rss_feed, :edit)", :given => "a rss_feed exists" do
#   before(:each) do
#     @response = request(resource(RssFeed.first, :edit))
#   end
#   
#   it "responds successfully" do
#     @response.should be_successful
#   end
# end
# 
# describe "resource(@rss_feed)", :given => "a rss_feed exists" do
#   
#   describe "GET" do
#     before(:each) do
#       @response = request(resource(RssFeed.first))
#     end
#   
#     it "responds successfully" do
#       @response.should be_successful
#     end
#   end
#   
#   describe "PUT" do
#     before(:each) do
#       @rss_feed = RssFeed.first
#       @response = request(resource(@rss_feed), :method => "PUT", 
#         :params => { :rss_feed => {:id => @rss_feed.id} })
#     end
#   
#     it "redirect to the rss_feed show action" do
#       @response.should redirect_to(resource(@rss_feed))
#     end
#   end
#   
# end
# 
