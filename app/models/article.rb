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
  has 1, :image
  
  before :destroy, :destroy_image
  
  is :searchable
  
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
    self.image.destroy
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
      parts = self.description.split("<br />")

      part = if parts.size > 1
        parts[1]
      else
        parts[0]
      end

      part.strip_html[0..size] + "..."
    else # use the fulltext if the description is empty         
      self.fulltext.strip_html[0..size] + "..."
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
  # @param [Hash] default_attrs the given attributes for the article
  #
  # @return [Article] the article with newly scraped attributes
  def import(attrs)
    self.attributes = parse(attrs)
    self.save
    self
  end
end
