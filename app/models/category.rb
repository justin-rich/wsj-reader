class Category
  include DataMapper::Resource
  
  property :id,         Serial
  property :name,       String, :length => 255
  property :short_name, String, :length => 255  
  property :display,    Boolean
  
  has n, :feeds
  has n, :articles  
  
  validates_with_method :name, :method => :check_name
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task  
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def self.reset
    `#{Settings.root}/bin/rake db:automigrate`
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
    Feed.all.each {|f| f.update_articles; sleep 2}    
  end
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  def self.load_source_data
    YAML::load(File.open("#{Settings.root}/config/feeds.yml")).each do |category|
      c = Category.create(:name => category["name"], :display => category["display"])
      
      next unless category["feeds"]
      
      category["feeds"].each do |feed|
        attrs = {:name => feed["name"], :url => feed["url"], :category => c}
        
        case feed["type"]
        when "PageOne"                
          PageOneageOne.create(attrs)
        when "Opinion"
          FeedOpinion.create(attrs)
        when "MoneyInvesting"
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
    self.articles(:active => true, :order => [ :priority ], :limit => size)
  end
  ##
  # Finds the highest priority active article with an image
  # 
  # @return [Article]
  def first_article_with_image
    arts = self.articles(:active => true, :order => [ :priority ])
    art = arts.detect {|a| a.image && a.image.thumbnail}
    
    if art
      art
    else
      self.articles.first
    end
  end
  ##
  # Returns a shorter name for the category -- used especially with mobile
  #
  # @return String
  def shortened_name
    self.short_name ? self.short_name : self.name
  end
  
  private
  
  ##
  # Checks the name for the category to make sure it is not empty
  #
  # @return [true, false] true if the name is valid, false otherwise
  def check_name
    unless self.name.blank?
      true
    else
      [false, "You must specify a name for the category"]
    end
  end
end
