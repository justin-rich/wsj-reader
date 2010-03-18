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
    
    # Keep track of which articles are in the feed    
    articles = []
    
    # For each item in the RSS feed    
    (self.doc/'item').each_with_index do |item, index|      
      # Create or update the article in the db
      articles << Article.factory(
                    :category => self.category,
                    :description => (item/'description').inner_html,
                    :rss_feed => self,
                    :url => (item/'link').inner_html,
                    :priority => index
                  )
    end
    
    # At this point active_articles includes the articles
    # that are currently in the source feed, plus any articles 
    # that were active on the previous import but, obviously 
    # were not in the feed. It is these active articles that are 
    # not in the feed that need to be deactivated.
    active_articles = self.articles(:active => true)
    
    active_articles.each do |article|
      # deactivate the article unless it is in the current feed
      article.deactivate unless articles.include?(article)
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
