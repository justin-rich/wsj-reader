class Category
  include DataMapper::Resource
  
  property :id,      Serial
  property :name,    String, :length => 255
  property :display, Boolean
  
  has n, :feeds
  has n, :articles  
  
  def self.reset
    `#{Merb.root}/bin/rake db:automigrate`
    load_source_data    
  end
  
  def self.update_articles
    Feed.all.each {|f| f.update_articles}    
  end
  
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
  
  def top_story
    stories = self.top_stories(1)
    
    unless stories.empty?
      stories.first
    else
      nil
    end
  end
  
  def top_stories(size = 3)
    self.articles(:active => true, :order => [ :feed_id, :priority ], :limit => size)
  end
  
  def first_article_with_image
    arts = self.articles(:order => [ :priority ])
    art = arts.detect {|a| a.image && a.image.thumbnail}
    
    if art
      art
    else
      self.articles.first
    end
  end
  
  def to_param
    CGI::escape("#{self.id}-#{self.name}")
  end
end
