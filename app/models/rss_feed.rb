class RssFeed < Feed    
  def get_source
    self.doc = begin
      Article.login
      Hpricot::XML(`curl -s -b #{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)
    rescue Exception => e
      p "There was a problem downloading the RSS feed"
      Hpricot::XML('')
    end
  end
  
  def get_new_articles
    # Download the RSS feed and save to self.doc
    get_source
    
    # Keep track of which articles are in the feed    
    articles = []
    
    # For each item in the RSS feed    
    (self.doc/'item').each_with_index do |item, index|      
      # Create or update the article in the db
      articles << Article.factory(
                    :category => self.category,
                    :description => (item/'description').inner_html,
                    :feed => self,
                    :url => (item/'link').inner_html,
                    :priority => index
                  )
    end
    
    articles
  end
end
