class FeedPageOne < Feed  
  def get_source
    self.doc = begin
      Article.login
      Hpricot(`curl -s -b #{Merb.root}/config/wsj/cookies.txt "http://online.wsj.com/page/us_in_todays_paper.html"`)
    rescue Exception => e
      p "There was a problem downloading the RSS feed"
      Hpricot('')
    end
  end
  
  def get_new_articles
    # Download the RSS feed and save to self.doc
    get_source
    
    # Keep track of which articles are in the feed    
    articles = []
    
    xpath = (self.doc/'//html/body/table/tr/td[2]/table/tr[3]/td/table/tr[9]/td/table/tr[4]/td')[0]
    
    # For each item in the RSS feed        
    (xpath/'a.bold80').each_with_index do |link, index|
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