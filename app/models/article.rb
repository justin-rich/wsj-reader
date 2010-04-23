class Article
  include DataMapper::Resource
  include WSJ::Parser
  
  property :id,          Serial
  property :url,         Text
  property :title,       String, :length => 255
  property :subtitle,    String, :length => 255
  property :author,      String, :length => 255
  property :pub_date,    String, :length => 255
  property :fulltext,    Text
  property :description, Text
  property :priority,    Integer
  property :active,      Boolean
  property :unread,      Boolean  
  property :attempts,    Integer
  property :created_at,  DateTime
  property :updated_at,  DateTime  
  
  belongs_to :feed
  belongs_to :category
  has 1,     :image
  
  before :destroy, :destroy_image
  
  is :searchable
  
  validates_with_method :url,      :method => :check_url
  validates_with_method :title,    :method => :check_title  
  validates_with_method :fulltext, :method => :check_fulltext
  validates_with_method :pub_date, :method => :check_pub_date
  validates_with_method :priority, :method => :check_priority  
  
  ##
  # Aricle factory - Creates or updates an Article
  #
  # @example Create an article for a Feed
  #  Article.factory(
  #             :category => Category.first,
  #             :description => 'Description',
  #             :feed => Feed.first,
  #             :url => "http://online.wsj.com/articles/1",
  #             :priority => 1
  #           )
  #
  # @param [Hash] attrs the default attrs to create or update an Article with
  # @option attrs [String] :url the url of the article (required)
  # @option attrs [Category] :category the Category the article's Feed belongs_to  
  # @option attrs [Feed] :feed the Feed the article belongs to
  # @option attrs [String] :description the description of the article
  # @option attrs [Integer] :priority the priority of the article for a Feed
  #
  # @return [Article] the newly created or updated article
  def self.factory(attrs)
    a = first(:url => attrs[:url])
    
    default_attrs = {
      :active => true,
      :attempts => a ? a.attempts + 1 : 0
    }
    
    attrs = attrs.merge(default_attrs)
    
    if a # If the article already exists
      # Scrape an article 2 additional times looking for images
      if a.fulltext.blank? && a.attempts < 2 
        a.import(attrs)
      else # After the 2 attempts, just start updating the article as active
        a.update(attrs)  
        a
      end                
    else # Otherwise, create a new article
      a = self.new(attrs)      
      a.import(attrs)
    end        
  end  
  ##
  # Mark the article as having been read
  #
  # @return [Boolean] 
  def mark_as_read
    self.update(:unread => false)
  end  
  ##
  # Mark the article as being inactive
  #
  # @return [Boolean]
  def deactivate
    self.update(:active => false)
  end  
  ##
  # Mark the article as being inactive
  #
  # @return [Boolean] true if sucessful, false otherwise
  def destroy_image
    return true if self.image.nil?
    self.image.destroy!
    self.reload
  end  
  ##
  # A short snippet of an article.
  #
  # @param [Integer] size the desired size of the snippet
  #
  # @return [String] a snippet of the article, without any HTML tags
  def desc(size=255)
    # Use the description
    unless description.blank?
      description.strip_html[0..size-4] + "..."
    else # use the fulltext if the description is empty         
      self.fulltext.strip_html[0..size-4] + "..."
    end    
  end  
  ##
  # A shorter version of the article for Page One
  #
  # @param [Integer] size the desired size of the short article
  #
  # @return [String] a short version of the article, with HTML tags
  def short_version(size=3000)
    parts = self.fulltext.split("</p>")
    
    parts.inject('') do |shortv, part|
      unless shortv.size + part.size >= size
        shortv << "#{part}</p>"
      else
        shortv
      end
    end
  end    
  ##
  # Sets the article's attributes to screen-scraped and given attributes
  #
  # @param [Hash] attrs the given attributes for the article
  #
  # @return [Article] the article with newly scraped attributes
  def import(attrs)
    self.attributes = parse(attrs)
    self.save
    self
  end
  
  private
  
  ##
  # Checks the URL to make sure it represents a real asset
  #
  # @return [true, false] true if the URL starts with 'http://', false otherwise
  def check_url
    if self.url && /^http\:\/\/(.*)/.match(self.url)
      true
    else
      [false, "You must specify a URL for an article"]
    end
  end  
  ##
  # Checks the title to make sure it is non-empty
  #
  # @return [true, false] true if the URL starts with 'http://', false otherwise
  def check_title
    unless self.title.blank?
      true
    else
      [false, "You must specify a title for an article"]
    end
  end
  ##
  # Checks the fulltext to make sure it is non-empty
  #
  # @return [true, false] true if the URL starts with 'http://', false otherwise
  def check_fulltext
    unless self.fulltext.blank?
      true
    else
      [false, "You must specify a title for an article"]
    end
  end
  ##
  # Checks the pub_date to make sure it is non-empty
  #
  # @return [true,false] true if the pub_date is not blank, false otherwise
  def check_pub_date
    unless self.pub_date.blank?
      true
    else
      [false, "You must specify a pub_date for an article"]
    end
  end
  ## 
  # Checks the priority field to make sure it is a non-zero integer
  #
  # @return [true, false]
  def check_priority
    unless self.priority.nil? || !self.priority.kind_of?(Integer)
      true
    else
      [false, "You must specify an integer priority for an article"]
    end
  end
end
