class Article
  include DataMapper::Resource
  
  attr_accessor :doc # tmp variable for the Hpricot doc
  
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
  

  # Create or update an article based on whether or not it's
  # already in the db (and keyed off of the article URL)
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
        a.attributes = attrs
      end
                 
      a.save
      a
    else # Otherwise, create a new article
      a = self.new(attrs)      
      a.import(attrs)
      a.save
      a
    end        
  end
  
  ##
  # Mark the article as having been read
  #
  # @param [Hash] default_attrs
  #
  # @return [Hash] the default_attrs merged with the attrs found in the HTML source
  def mark_as_read
    self.update(:unread => false)
  end
  
  def desc(size=255)
    unless description.blank?
      parts = self.description.split("<br />")

      part = if parts.size > 1
        parts[1]
      else
        parts[0]
      end

      part.strip_html[0..size] + "..."
    else            
      self.fulltext.strip_html[0..size] + "..."
    end    
  end
  
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
  
  def deactivate
    self.update(:active => false)
  end
  
  def destroy_image
    return true if self.image.nil?
    self.image.destroy
  end
  
  # After an Article is saved (given a URL), this will download
  # the article's URL, and will save the Article's attributes to 
  # the database
  ##
  # Download the article, then screen-scrape the articles elements
  #
  # @param [Hash] default_attrs
  #
  # @return [Hash] the default_attrs merged with the attrs found in the HTML source
  def import(default_attrs = {})
    self.attributes = scrape_info(default_attrs)
  end
  
  ##
  # Download the article, then screen-scrape the articles elements
  #
  # @param [Hash] default_attrs
  #
  # @return [Hash] the default_attrs merged with the attrs found in the HTML source
  def scrape_info(default_attrs)    
    attrs = {
      :title    => get_title,
      :subtitle => get_subtitle,
      :author   => get_author,
      :pub_date => get_pub_date,
      :fulltext => get_fulltext,
      :image    => get_image
    }
    
    attrs.merge(default_attrs)    
  end
end
