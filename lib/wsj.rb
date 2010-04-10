module WSJ
  class Downloader
    attr_accessor :url, :timeout, :source
    
    # Setup the cookies to download protected URLs on wsj.com
    def initialize(_url, _timeout = 20)
      login      
      self.url = _url
      self.timeout = _timeout
      self.source = get_response
    end
    
    def login
      begin
        File.open("#{Merb.root}/config/wsj/cookies.txt").read      
      rescue Exception => e
        `curl -s -c #{Merb.root}/config/wsj/cookies.txt http://online.wsj.com/home-page`      
        `curl -s -c #{Merb.root}/config/wsj/cookies.txt -d "user=justin@justinrich.com&password=2p2aia5" http://commerce.wsj.com/auth/submitlogin`      
      end

      true
    end
    
    def get_source
      begin
        timeout(self.timeout) do |index|
          p "Downloading #{self.url} (#{index+1})"
          `curl -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`        
        end
      rescue Exception => e
        p "There was an error downloading #{self.url}"
        p e
        p e.backtrace
      end
    end    
  end
    # 
    # class Article    
    # 
    #   def get_html
    #     5.times do      
    #       begin
    #         Article.login
    #         p "Downloading #{url}"
    #         timeout(20) do
    #           time1 = Time.now                  
    #           html = Hpricot(`curl -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`)          
    #           p "Took #{Time.now-time1} seconds"
    #           return html
    #         end
    #       rescue Exception => e
    #         p "There was a problem downloading the article"
    #         p e
    #         next
    #       end
    #     end  
    # 
    #   end
    # 
    #   def get_title
    #     clean((self.doc/'h1').inner_html)
    #   end
    # 
    #   def get_subtitle
    #     clean((self.doc/'h2.subhead').inner_html)
    #   end
    # 
    #   def get_author
    # 
    #     if (self.doc/'h3.byline').size > 0
    #       tmp = ''      
    #       byline = (self.doc/'h3.byline').inner_text
    #       byline.split(" ").each do |word|
    #         unless /and/i.match(word)
    #           tmp << "#{word.capitalize} "          
    #         else
    #           tmp << "#{word.downcase} "
    #         end
    #       end
    #       clean(tmp)
    # 
    #     else
    #       (self.doc/'li.byline/h3').inner_text
    #     end
    # 
    #   end
    # 
    #   def get_pub_date
    #     clean((self.doc/'li.dateStamp/small').inner_html)
    #   end
    # 
    #   def get_fulltext
    #     tmpdoc = Hpricot((self.doc/'div.articlePage').inner_html) # clone the existing doc to safely remove some HTML
    #     (tmpdoc/'div').remove
    #     (tmpdoc/'h3').remove    
    #     tmpdoc.search('p').inject('') do |paragraphs, paragraph|
    #       paragraphs << paragraph.to_html.transliterate
    #     end
    #   end
    # 
    #   def get_image
    #     unless (img = (self.doc/'div.articlePage').at("img")).nil?
    #       self.image = Image.new(:url => img.attributes["src"], 
    #                      :caption => (self.doc/'p.targetCaption').inner_html,
    #                      :article => self,
    #                      :active  => true)
    #     else
    #       nil
    #     end
    #   end
    # 
    #   # Consolidates multipe white space characters into one
    #   #
    #   # @param [String, #gsub] str the string to manipulate
    #   # @return [String] with no more than one white space character consecutively
    #   def clean(str)
    #     str.gsub(/\s+/, ' ').strip
    #   end
    # end
end