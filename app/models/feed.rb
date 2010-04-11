class Feed
  attr_accessor :doc # tmp variable to hold source xml during updates
  
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :length => 255
  property :url,  String, :length => 255
  property :type, Discriminator 
  
  has n, :articles
  belongs_to :category  
  ##
  # Download active articles, deactive old articles
  def update_articles
    new_articles = get_new_articles
    deactivate_old_articles(new_articles)
  end  
  ##
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
      unless current_articles.include?(article)
        article.deactivate 
        article.image.deactivate unless article.image.nil?
      end
    end
  end
  ##
  # Gets a list of articles currently in the feed
  #
  # @abstract Subclass and override {#get_source} to implement a custom class for importing articles.
  #
  # @return [Array<Article>] the list of article currently in the feed
  def get_new_articles
    raise NotImplemented    
  end
  ##
  # Sets doc variable as the source document for a list of articles 
  #
  # @abstract Subclass and override {#get_source} to implement a custom class for importing articles.
  def get_source
    raise NotImplemented
  end
end
