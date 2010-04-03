class Image
  include DataMapper::Resource
  
  property :id,      Serial
  property :url,     String, :length => 255
  property :caption, Text

  belongs_to :article
  
  # after :create, :save_category
  
  def thumbnail
    self.url.gsub!(/_[A-Z]_/, "_A_")
  end
  
  def midsize
    self.url.gsub(/_[A-Z]_/, "_D_")
  end
  
  def fullsize
    self.url.gsub(/_[A-Z]_/, "_G_")
  end
end
