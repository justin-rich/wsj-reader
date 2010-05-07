class HttpResource
  attr_accessor :url, :connect_timeout, :contents
  ##
  # Instantiates HttpResource
  # 
  # @param [String] url the resource to download
  # @param [Integer] timeout the timeout limit in seconds
  #
  # @return [Downloader]
  def initialize(url, test = false, connect_timeout = 20)
    login
    self.url = url
    self.connect_timeout = connect_timeout
    self.contents = unless test
      download_contents
    else
      '<html><head><title>Test</title></head><body><h1>Test</h1></body></html>'
    end
  end  
  ##
  # Ensures a cookie is set, which serves as authentication for 
  # other connections.
  #
  # @return [true]
  def login
    begin
      File.open("#{Merb.root}/config/wsj/cookies.txt").read      
    rescue Exception => e
      `curl  -s -c #{Merb.root}/config/wsj/cookies.txt http://online.wsj.com/home-page`      
      `curl  -s -c #{Merb.root}/config/wsj/cookies.txt -d "user=justin@justinrich.com&password=2p2aia5" http://commerce.wsj.com/auth/submitlogin`      
    end
    true
  end
  ##
  # Gets the response from wsj.com
  #
  # @return [String] the contents of the downloaded URL asset, or
  #   an empty string if there was a problem downloading the article
  def download_contents
    5.times do |index|
      begin
        p "Downloading #{self.url} (#{index+1})"
        return  `curl -L -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`        
      rescue Exception => e
        p "There was an error downloading #{self.url}"
        p e
        p e.backtrace          
      end
    end    
    ''         
  end         
end