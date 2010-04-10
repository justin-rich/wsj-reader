class Image
  include DataMapper::Resource
  
  property :id,      Serial
  property :url,     String, :length => 255
  property :caption, Text
  property :active,  Boolean
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :article
  
  # after :create, :save_category
  def deactivate
    self.update(:active => false)
  end
  
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
