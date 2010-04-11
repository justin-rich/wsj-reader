class HtmlFeed < Feed
  ##
  # Sets doc variable as the source document for a list of articles 
  def get_source
    html = Downloader.new(self.url)
    self.doc = Hpricot(html.source)
  end
end
