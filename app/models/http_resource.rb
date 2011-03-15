class HttpResource
  attr_accessor :url, :connect_timeout, :contents
  ##
  # Instantiates HttpResource
  # 
  # @param [Integer] timeout the timeout limit in seconds  
  # @param [String] url the resource address to download
  #
  # @return [HttpResource]
  def initialize(url, connect_timeout = 20, test = false)
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
      File.open("#{Settings.root}/tmp/cookies.txt").read      
    rescue Exception => e
      `curl --user-agent "#{user_agent}" -s -c #{Settings.root}/tmp/cookies.txt http://online.wsj.com/home-page`      
      `curl --user-agent "#{user_agent}" -s -c #{Settings.root}/tmp/cookies.txt -d "user=justin@justinrich.com&password=2p2aia5" http://commerce.wsj.com/auth/submitlogin`      
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
        return  `curl --user-agent "#{user_agent}" -L -s -b#{Settings.root}/tmp/cookies.txt "#{self.url}"`        
      rescue Exception => e
        p "There was an error downloading #{self.url}"
        p e
        p e.backtrace          
      end
    end    
    ''         
  end     
  ##
  # The user agent to pass to the HTTP server
  def user_agent
    "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/3B48b Safari/419.3"
  end 
end