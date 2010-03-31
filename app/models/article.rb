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
  
  # Setup the cookies to download protected URLs on wsj.com
  def self.login
    begin
      File.open("#{Merb.root}/config/wsj/cookies.txt").read      
    rescue Exception => e
      `curl -s -c #{Merb.root}/config/wsj/cookies.txt http://online.wsj.com/home-page`      
      `curl -s -c #{Merb.root}/config/wsj/cookies.txt -d "user=justin@justinrich.com&password=2p2aia5" http://commerce.wsj.com/auth/submitlogin`      
    end
    
    true
  end
  
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
      if a.image.nil? && a.attempts < 2 
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
  
  # Mark the article as having been read
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

      part.strip_html[0..size]   
    else            
      self.fulltext.strip_html[0..size] + "..."
    end    
  end
  
  def deactivate
    self.update(:active => false)
  end
  
  
  # After an Article is saved (given a URL), this will download
  # the article's URL, and will save the Article's attributes to 
  # the database
  
  def import(default_attrs)
    self.attributes = scrape_info(default_attrs)
  end
  
  def scrape_info(default_attrs)
    self.doc = get_html
    
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
  
  def get_html
    begin
      Article.login
      time1 = Time.now
      p "Downloading #{url}"
      html = Hpricot(`curl -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)
      p "Took #{Time.now-time1} seconds"
      html
    rescue Exception => e
      p "There was a problem downloading the article"
      Hpricot('')
    end
  end
  
  def get_title
    clean((self.doc/'h1').inner_html)
  end
  
  def get_subtitle
    clean((self.doc/'h2.subhead').inner_html)
  end
  
  def get_author
    
    if (self.doc/'h3.byline').size > 0
      tmp = ''      
      byline = (self.doc/'h3.byline').inner_text
      byline.split(" ").each do |word|
        unless /and/i.match(word)
          tmp << "#{word.capitalize} "          
        else
          tmp << "#{word.downcase} "
        end
      end
      clean(tmp)
      
    else
      (self.doc/'li.byline/h3').inner_text
    end

  end
  
  def get_pub_date
    clean((self.doc/'li.dateStamp/small').inner_html)
  end
  
  def get_fulltext
    tmpdoc = Hpricot((self.doc/'div.articlePage').inner_html) # clone the existing doc to safely remove some HTML
    (tmpdoc/'div').remove
    (tmpdoc/'h3').remove    
    tmpdoc.search('p').inject('') do |paragraphs, paragraph|
      paragraphs << paragraph.to_html
    end
  end
  
  def get_image
    unless (img = (self.doc/'div.articlePage').at("img")).nil?
      self.image = Image.new(:url => img.attributes["src"], 
                     :caption => (self.doc/'p.targetCaption').inner_html,
                     :article => self)
    else
      nil
    end
  end
  
  def clean(str)
    str.gsub(/\s+/, ' ').strip
  end
  
  def destroy_image
    return true if self.image.nil?
    self.image.destroy
  end
end
