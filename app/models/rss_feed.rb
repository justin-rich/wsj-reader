class RssFeed < Feed
  ##
  # Sets doc variable as the source document for a list of articles     
  def get_source
    xml = Downloader.new(self.url)
    self.doc = Hpricot::XML(xml.source)
  end
  ##
  # Gets a list of articles currently in the feed
  #
  # @return [Array<Article>] the list of article currently in the feed
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
