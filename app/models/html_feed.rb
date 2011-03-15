class HtmlFeed < Feed
  ##
  # Sets doc variable as the source document for a list of articles 
  def get_source
    html = HttpResource.new(self.url.gsub("date", pubdate))
    self.doc = Hpricot(html.contents)
  end
    
  ##
  # Finds the latest date of issue
  #   WSJ runs Mon-Fri with Front Page, Onipion, and Money & Investing
  #   so, on the weekend returns the previous Friday, either 24 or 48 
  #   hours ago in yyyymmdd
  def pubdate(format="%Y%m%d")
    t = Time.now
    
    case t.strftime("%A")
    when 'Saturday'
      (t-(48*60*60)).strftime(format)      
    when 'Sunday'
      (t-(24*60*60)).strftime(format)
    else
      t.strftime(format)
    end
  end
  
  # Downloads and scrapes the Today's Paper section of wsj.com
  #
  # @return [Array<Article>] list of articles in section currently  
  def get_new_articles
    # Download the RSS feed and save to self.doc
    get_source
    
    # Keep track of which articles are in the feed    
    articles = []
    
    article_links = (self.doc/'li.mjItemMain').collect do |mjItem|
      mjItem.at('a.mjLinkItem')
    end
    
    # For each item in the RSS feed        
    article_links.each_with_index do |link, index|
      
      # Create or update the article in the db
      articles << Article.factory(
                    :category => self.category,
                    :description => '',
                    :feed => self,
                    :url => "http://online.wsj.com#{link.attributes['href']}",
                    :priority => index
                  )
    end
    
    articles
  end
end
