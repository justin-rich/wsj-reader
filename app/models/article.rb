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
  
  belongs_to :rss_feed
  belongs_to :category
  has 1, :image
  
  after :create, :import
  
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
    
    if a
      a.update_attributes(:active => true, 
                          :priority => attrs[:priority], 
                          :description => attrs[:description])
                          
      a                    
    else
      self.create(attrs)          
    end    
  end
  
  # Mark the article as having been read
  def mark_as_read
    self.update_attributes(:unread => false)
  end
  
  def desc(size=255)
    return '' if description.blank?
    
    parts = self.description.split("<br />")
    
    part = if parts.size > 1
      parts[1]
    else
      parts[0]
    end
    
    p part
    
    part.strip_html[0..size]    
  end
  
  def deactivate
    self.update_attributes(:active => false)
  end
  
  
  # After an Article is saved (given a URL), this will download
  # the article's URL, and will save the Article's attributes to 
  # the database
  
  def import
    self.doc = get_html 
    
    attrs = {
      :title    => get_title,
      :subtitle => get_subtitle,
      :author   => get_author,
      :pub_date => get_pub_date,
      :fulltext => get_fulltext,
      :image    => get_image
    }
    
    self.update_attributes(attrs)
  end
  
  def get_html
    begin
      Article.login
      Hpricot(`curl -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)
    rescue Exception => e
      p "There was a problem downloading the article"
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
end
