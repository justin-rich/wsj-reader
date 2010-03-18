class Application < Merb::Controller
  before :find_categories
  before :serve_mobile
  
  def serve_mobile
    self.content_type = :mobile if is_mobile_device?
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