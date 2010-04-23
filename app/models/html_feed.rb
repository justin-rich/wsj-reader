class HtmlFeed < Feed
  ##
  # Sets doc variable as the source document for a list of articles 
  def get_source
    html = HttpResource.new(self.url)
    self.doc = Nokogiri::HTML(html.contents)
  end
end
