require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Category, 'in general' do
  before(:each) do
    @category = Category.new
  end
  
  it "should be valid with valid attributes" do
    @category.attributes = Factory.attributes_for(:category)    
    @category.should be_valid
  end
  
  it "should be invalid without a name" do
    @category.attributes = Factory.attributes_for(:category).except(:name)
    @category.should_not be_valid
  end
end

describe Category, "when passed first_article_with_image when there is an article with an image" do
  before(:all) do
    @category = Factory.create(:category)
    Factory.create(:article)
    Factory.create(:image)
  end
  
  it "should return an article" do
    @category.first_article_with_image.should be_a_kind_of(Article)
  end
  
  it "should return an article with an image" do
    @category.first_article_with_image.image.should_not be_nil
  end
end


describe Category, "when passed first_article_with_image when there are no articles with an image" do
  before(:all) do
    @category = Factory.create(:category)
    Factory.create(:article)
  end
  
  it "should return an article" do
    @category.first_article_with_image.should be_a_kind_of(Article)
  end
  
  it "should return an article without an image" do
    @category.first_article_with_image.image.should be_nil
  end
end

describe Category, "when passed top_stories" do
  before(:all) do
    @category = Factory.create(:category)
    @article = Factory.create(:article)
  end
  
  it "should return an array of stories no bigger than the given size" do
    @category.top_stories(1).size.should <= 1
  end
end

describe Category, "when passed top_story" do  
  it "should return an Article instance if there are active stories for the category" do
    @category = Factory.create(:category)
    @article = Factory.create(:article)
    @category.top_story.should be_a_kind_of(Article)
  end
  
  it "should return nil if there are no active stories for the category" do
    @category = Factory.create(:category)
    @category.top_story.should be_nil
  end
end