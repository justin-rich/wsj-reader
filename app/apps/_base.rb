module WSJ
  # Setup sinatra configuration
  class Base < Sinatra::Base
    configure do
      use Rack::Session::Cookie, 
        :secret => 'The WSJ is a front for drug laundering'
      set :raise_errors, false
      set :dump_errors, true
      set :methodoverride, true
      set :show_exceptions, false
      set :static, true
      set :root, Settings.root
    end
    
    helpers do
      def herb(page, locals={})
        unless is_mobile_device?
          erb(page, {:layout => :"../layout.erb"}, locals)        
        else
          erb(:"mobile_#{page}", {:layout => :"../mobile_layout.erb"}, locals)
        end
      end
      
      def partial(page, locals={})
        erb(page, {:layout => false}, locals)
      end
      
      def whats_news_print(article, first=false)
        parts = article.desc(255).split(" ")

        bolded_parts = if first
          parts.slice(0, 2).join(" ")        
        else
          parts.slice(0, 4).join(" ")
        end

        unbolded_parts =( parts - bolded_parts.split(" ")).join(" ")

        bolded_words = if first
          "<span class=\"capital\">" + bolded_parts[0,1] + "</span>" + bolded_parts[1,bolded_parts.size]
        else
          bolded_parts
        end

        square = if first
          ""
        else
          "&#9632;"
        end

        square + "<a href=\"/news/#{article.id}\"> <b>" + bolded_words + "</b> " + unbolded_parts + "</a>"      
      end
    end
    
    not_found do
      "Not Found"
    end
    
    error do
      "Error"
    end
    
    before do
      find_categories
    end

    MOBILE_USER_AGENTS =  'palm|palmos|palmsource|iphone|blackberry|nokia|phone|midp|mobi|pda|' +
                          'wap|java|nokia|hand|symbian|chtml|wml|ericsson|lg|audiovox|motorola|' +
                          'samsung|sanyo|sharp|telit|tsm|mobile|mini|windows ce|smartphone|' +
                          '240x320|320x320|mobileexplorer|j2me|sgh|portable|sprint|vodafone|opwv|' +
                          'mot-|sec-|lg-|sie-|up.b|up/'

    def is_mobile_device?
      request.user_agent.to_s.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
    end
    
    def find_categories
      @categories = Category.all
    end
  end
end