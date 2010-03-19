class Feed
  attr_accessor :doc # tmp variable to hold source xml during updates
  
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :length => 255
  property :url,  String, :length => 255
  property :type, Discriminator 
  
  has n, :articles
  belongs_to :category
  
  
  # Download active articles, deactive old articles
  def update_articles
    new_articles = get_new_articles
    deactivate_old_articles(new_articles)
  end
  
  # Deactivate articles that are active, but are not in 
  # the feed (aka old articles)
  def deactivate_old_articles(current_articles)
    # At this point active_articles includes the articles
    # that are currently in the source feed, plus any articles 
    # that were active on the previous import but, obviously 
    # were not in the feed. It is these active articles that are 
    # not in the feed that need to be deactivated.
    active_articles = self.articles(:active => true)
    
    active_articles.each do |article|
      # deactivate the article unless it is in the current feed
      article.deactivate unless current_articles.include?(article)
    end
  end
  
  # Uses cookie authentication to download the source
  # RSS feeds
  def get_source
    self.doc = begin
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
