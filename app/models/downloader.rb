class Downloader
  attr_accessor :url, :timeout, :source
  ##
  # Setup the cookies to download protected URLs on wsj.com
  # 
  # @param [String] url the resource to download
  # @param [Integer] timeout the timeout limit in seconds
  #
  # @return [Downloader]
  def initialize(url, timeout = 20)
    login      
    self.url = url
    self.timeout = timeout
    self.source = get_source
  end  
  ##
  # Login to WSJ by initializizing a connection, authenticating, then 
  # saving the cookies set for use later
  #
  # @return [true]
  def login
    begin
      File.open("#{Merb.root}/config/wsj/cookies.txt").read      
    rescue Exception => e
      `curl --connect-timeout #{self.timeout} -s -c #{Merb.root}/config/wsj/cookies.txt http://online.wsj.com/home-page`      
      `curl --connect-timeout #{self.timeout} -s -c #{Merb.root}/config/wsj/cookies.txt -d "user=justin@justinrich.com&password=2p2aia5" http://commerce.wsj.com/auth/submitlogin`      
    end
    true
  end
  ##
  # Get the source of a URL
  #
  # @return [String] the contents of the downloaded URL asset, or
  #   an empty string if there was a problem downloading the article
  def get_source
    5.times do |index|
      begin
        p "Downloading #{self.url} (#{index+1})"
        return `curl --connect-timeout #{self.timeout} -s -b#{Merb.root}/config/wsj/cookies.txt "#{self.url}"`        
      rescue Exception => e
        p "There was an error downloading #{self.url}"
        p e
        p e.backtrace          
      end
    end    
    ''         
  end         
end