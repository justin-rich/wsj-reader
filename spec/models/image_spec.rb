require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Image, "in general" do  
  before(:each) do
    @image = Image.new
  end
  
  it "should be valid with valid attributes" do
    @image.attributes = Factory.attributes_for(:image)
    @image.should be_valid
  end
  
  it "should be invalid without a URL" do
    @image.attributes = Factory.attributes_for(:image).except(:url)
    @image.should_not be_valid
  end
  
  it "should be invalid without a valid URL" do
    @image.attributes = Factory.attributes_for(:image).except(:url)
    @image.url = "not_a_url"
    @image.should_not be_valid
  end
    
  it "should be invalid without an associated article" do
    @image.attributes = Factory.attributes_for(:image).except(:article_id)
    @image.should_not be_valid
  end
  
  it "should be valid without a caption" do
    @image.attributes = Factory.attributes_for(:image).except(:caption)
    @image.should be_valid
  end
end

describe Image, "when passed deactivate" do    
  before(:each) do
    Factory.create(:image)
  end
  
  it "should set the active field to false" do
    i = Image.first(:url => Factory.attributes_for(:image)[:url])
    i.deactivate
    i.active.should == false
  end
end

describe Image, "when passed thumbnail" do
  before(:each) do
    @image = Factory.create(:image)
  end
  
  it "should return a URL with _A_ in it (representing size on wsj.com)" do
    @image.thumbnail.should match(/_A_/)
  end
end

describe Image, "when passed midsize" do
  before(:each) do
    @image = Factory.create(:image)
  end
  
  it "should return a URL with _D_ in it (representing size on wsj.com)" do
    @image.midsize.should match(/_D_/)
  end
end

describe Image, "when passed fullsize" do
  before(:each) do
    @image = Factory.create(:image)
  end
  
  it "should return a URL with _G_ in it (representing size on wsj.com)" do
    @image.fullsize.should match(/_G_/)
  end
end