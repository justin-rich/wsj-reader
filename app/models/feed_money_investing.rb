class FeedMoneyInvesting < HtmlFeed
  # Downloads and scrapes the Money & Investigation section of wsj.com
  #
  # @return [Array<Article>] list of articles in section currently  
  def get_new_articles
    # Download the RSS feed and save to self.doc
    get_source
    
    # Keep track of which articles are in the feed    
    articles = []
    
    section = doc.xpath('//html/body/table/tr/td[2]/table/tr[3]/td/table/tr[9]/td/table/tr[4]/td')[1]
    
    # For each item in the RSS feed        
    (section/'a.bold80').each_with_index do |link, index|
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
