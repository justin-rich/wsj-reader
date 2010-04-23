class Image
  include DataMapper::Resource
  
  property :id,      Serial
  property :url,     String, :length => 255
  property :caption, Text
  property :active,  Boolean
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :article
  
  validates_with_method :url, :method => :check_url
    
  ##
  # Deactivates the article
  #
  # @return [Boolean] true if successful, false otherwise
  def deactivate
    self.update(:active => false)
  end  
  ##
  # The URL for the thumbnail sized version of the image
  #
  # @return [String]
  def thumbnail
    self.url.gsub!(/_[A-Z]_/, "_A_")
  end
  ##
  # The URL for the medium sized version of the image
  #
  # @return [String]
  def midsize
    self.url.gsub(/_[A-Z]_/, "_D_")
  end
  ##
  # The URL for the large sized version of the image
  #
  # @return [String]
  def fullsize
    self.url.gsub(/_[A-Z]_/, "_G_")
  end
  
  private
  
  ##
  # Check the URL to make sure it represents a real asset
  #
  # @return [true, false] true if the URL starts with 'http://', false otherwise
  def check_url
    if self.url && /^http\:\/\/(.*)/.match(self.url)
      true
    else
      [false, "You must specify a URL for an image"]
    end
  end
end
