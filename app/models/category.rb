class Category
  include DataMapper::Resource
  
  property :id,      Serial
  property :name,    String, :length => 255
  property :display, Boolean
  
  has n, :feeds
  has n, :articles  
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task  
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def self.reset
    `#{Merb.root}/bin/rake db:automigrate`
    load_source_data    
  end
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task  
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def self.update_articles
    Feed.all.each {|f| f.update_articles; sleep 60}    
  end
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def self.load_source_data
    YAML::load(File.open("#{Merb.root}/config/feeds.yml")).each do |category|
      c = Category.create(:name => category["name"], :display => category["display"])
      
      next unless category["feeds"]
      
      category["feeds"].each do |feed|
        attrs = {:name => feed["name"], :url => feed["url"], :category => c}
        
        case feed["type"]
        when "FeedPageOne"                
          FeedPageOne.create(attrs)
        when "FeedOpinion"
          FeedOpinion.create(attrs)
        when "FeedMoneyInvesting"
          FeedMoneyInvesting.create(attrs)                    
        else
          RssFeed.create(attrs)          
        end
      end
    end    
  end  
  ##
  # Finds the top story for the category
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def top_story
    stories = self.top_stories(1)
    
    unless stories.empty?
      stories.first
    else
      nil
    end
  end  
  ##
  # Finds a set of top stories for the category
  #
  # @param [Integer] size the desired number of articles
  #
  # @return [Array<Article>] the highest priority active articles for the category
  def top_stories(size = 3)
    self.articles(:active => true, :order => [ :feed_id, :priority ], :limit => size)
  end
  ##
  # Finds the highest priority active article with an image
  # 
  # @return [Article]
  def first_article_with_image
    arts = self.articles(:order => [ :priority ])
    art = arts.detect {|a| a.image && a.image.thumbnail}
    
    if art
      art
    else
      self.articles.first
    end
  end
end
