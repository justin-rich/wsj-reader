class Image
  include DataMapper::Resource
  
  property :id,      Serial
  property :url,     String, :length => 255
  property :caption, Text
  property :active,  Boolean
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :article
    
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
end
