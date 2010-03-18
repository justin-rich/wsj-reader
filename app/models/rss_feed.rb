class RssFeed
  include DataMapper::Resource
  
  attr_accessor :doc # tmp variable to hold source xml during updates
  
  property :id,   Serial
  property :name, String, :length => 255
  property :url,  String, :length => 255
  
  has n, :articles
  belongs_to :category
  
  
  # Update the articles in an RSS feed
  def update_articles
    # Download the RSS feed
    self.doc = get_source
    
    # For each item in the RSS feed    
    (self.doc/'item').each_with_index do |item, index|
      
      # Create or update the article in the db
      Article.factory(:category => self.category,
                      :description => (item/'description').inner_html,
                      :rss_feed => self,
                      :url => (item/'link').inner_html,
                      :priority => index,
                      :active => true)
    end
  end
  
  
  # Uses cookie authentication to download the source
  # RSS feeds
  def get_source
    begin
      Article.login
      Hpricot::XML(`curl -s -c #{Merb.root}/wsj/cookies.txt "#{self.url}"`)
    rescue Exception => e
      p "There was a problem downloading the RSS feed"
      Hpricot::XML('')
    end
  end
  
  # Base a feed's priority on the time it was created
  # Consider expanding this to a db column if necessary 
  # to add feeds asynchonously
  def priority
    id
  end
end
