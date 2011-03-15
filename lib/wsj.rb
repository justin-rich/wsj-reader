module WSJ
  module Parser    
    attr_accessor :doc    
    ##
    # Download the article, then screen-scrape the articles elements
    #
    # @param [Hash] default_attrs article properties not found in the HTML
    # @option default_attrs [String] :title The title of the Article
    # @option default_attrs [String] :subtitle The subtitle of the Article
    # @option default_attrs [String] :author The author of the article
    # @option default_attrs [String] :pub_date The pubDate of the article
    # @option default_attrs [String] :fulltext The fulltext of the article  
    # @option default_attrs [String] :image The image for the article
    #
    # @return [Hash] the default article attributes merged with the screen-scraped attributes
    def parse(default_attrs = {})    
      self.doc = get_doc(default_attrs[:url])
      
      attrs = {
        :title    => get_title,
        :subtitle => get_subtitle,
        :author   => get_author,
        :pub_date => get_pub_date,
        :fulltext => get_fulltext,
        :image    => get_image
      }
            
      attrs.merge(default_attrs)          
    end
    ##
    # Gets the Hpricot::HTML doc for the article
    #
    # @return [Hpricot::HTML]
    def get_doc(url)
       Hpricot(HttpResource.new(url).contents)
    end  
    ##
    # Scrapes the title for an article
    #
    # @return [String] the cleaned title of an article
    def get_title
      clean((self.doc/'h1').inner_html)
    end
    ##
    # Scrapes the subtitle for an article
    #
    # @return [String] the cleaned subtitle of an article
    def get_subtitle
      clean((self.doc/'h2.subhead').inner_html)
    end
    ##
    # Scrapes the author for an article
    #
    # @return [String] the cleaned author of an article
    def get_author
      if (self.doc/'h3.byline').size > 0
        tmp = ''      
        byline = (self.doc/'h3.byline').inner_text
        byline.split(" ").each do |word|
          unless /and/i.match(word)
            tmp << "#{word.capitalize} "          
          else
            tmp << "#{word.downcase} "
          end
        end
        clean(tmp)
      else
        (self.doc/'li.byline/h3').inner_text
      end
  
    end
    ##
    # Scrapes the pubDate for an article
    #
    # @return [String] the cleaned pubDate of an article
    def get_pub_date
      clean((self.doc/'li.dateStamp/small').inner_html)
    end
    ##
    # Scrapes the fulltext for an article
    #
    # @return [String] the cleaned fulltext of an article
    def get_fulltext
      begin
        tmpdoc = Hpricot(self.doc.at('div.articlePage').inner_html) # clone the existing doc to safely remove some HTML
        (tmpdoc/'div').remove
        (tmpdoc/'h3').remove

        _fulltext = ''
        tmpdoc.search('p').each do |paragraph|
          _fulltext << paragraph.to_html.transliterate
        end
        _fulltext
      rescue Exception => e
        ''
      end
    end
    ##
    # Scrapes the image for an article
    #
    # @return [Image, nil] the image for an article, or nil if there is not an image
    def get_image
      unless (img = (self.doc/'div.articlePage').at("img")).nil?
        self.image = Image.new(:url => img.attributes["src"], 
                       :caption => (self.doc/'p.targetCaption').inner_html,
                       :article => self,
                       :active  => true)
      else
        nil
      end
    end    
    ##
    # Consolidates multipe white space characters into one
    #
    # @param [#gsub] str the string to manipulate
    #
    # @return [String] with no more than one white space character consecutively
    def clean(str)
      str.gsub(/\s+/, ' ').strip
    end
  end
end