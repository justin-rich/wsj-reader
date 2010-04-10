class HtmlFeed < Feed
  def get_source
    5.times do
      begin
        Article.login
        timeout(10) do
          self.doc = Nokogiri::HTML(`curl -s -b #{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)          
        end
        p self.doc.to_html
        return
      rescue Exception => e
        p "There was a problem downloading the RSS feed"
        p e 
        p e.backtrace
        next
      end
    end
  end
end
