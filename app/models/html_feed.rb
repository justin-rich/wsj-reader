class HtmlFeed < Feed
  def get_source
    5.times do
      begin
        Article.login
        self.doc = Nokogiri::HTML(`curl -s -b #{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)
        return
      rescue Exception => e
        p "There was a problem downloading the RSS feed"
        next
      end
    end
  end
end
