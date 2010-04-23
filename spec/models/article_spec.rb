require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Article do
  before(:each) do
    @article = Article.new
  end
  
  it "should be valid with valid attributes" do
    @article.attributes = Factory.attributes_for(:article)
    @article.should be_valid
  end
  
  it "should be invalid without a URL" do
    @article.attributes = Factory.attributes_for(:article).except(:url)
    @article.should_not be_valid
  end
  
  it "should be invalid with an invalid URL" do
    @article.attributes = Factory.attributes_for(:article).except(:url)
    @article.url = 'not_a_url'
    @article.should_not be_valid
  end
  
  it "should be invalid without a title" do
    @article.attributes = Factory.attributes_for(:article).except(:title)
    @article.should_not be_valid
  end
  
  it "should be valid with or without a subtitle" do
    @article.attributes = Factory.attributes_for(:article).except(:subtitle)
    @article.should be_valid
  end
    
  it "should be valid with or without an author" do
    @article.attributes = Factory.attributes_for(:article).except(:author)
    @article.should be_valid
  end
  
  it "should be invalid without a pubDate" do
    @article.attributes = Factory.attributes_for(:article).except(:pub_date)
    @article.should_not be_valid
  end
  
  it "should be invalid without fulltext" do
    @article.attributes = Factory.attributes_for(:article).except(:fulltext)
    @article.should_not be_valid
  end
  
  it "should be valid with or without a description" do
    @article.attributes = Factory.attributes_for(:article).except(:description)
    @article.should be_valid
  end
  
  it "should be invalid without a priority" do
    @article.attributes = Factory.attributes_for(:article).except(:priority)
    @article.should_not be_valid
  end
  
  it "should be valid with or without active set" do
    @article.attributes = Factory.attributes_for(:article).except(:active)
    @article.should be_valid
  end
end

describe Article, "factory" do
  before(:all) do  
    @article = call_article_factory    
  end
  
  def call_article_factory
    attrs = Factory.attributes_for(:article)
  
    Article.factory(
      :category => Factory.create(:category),
      :description => attrs[:description],
      :feed => Factory.create(:feed),
      :url => attrs[:url],
      :priority => attrs[:priority]
    )
  end
  
  it "should return an instance of an article" do        
    @article.should be_a_kind_of(Article)
  end
  
  it "should return an active article" do
    @article.active.should == true
  end
  
  it "should set the attempts count to zero for a new article" do
    @article.attempts.should == 0
  end
  
  it "should increment the attempts count for an existing article" do
    @existing_article = call_article_factory
    @existing_article.attempts.should == 1
  end
end

describe Article, "when passed desc" do
  before(:each) do
    @article = Factory.build(:article)
  end
  
  it "should return a non-empty string" do
    @article.desc.size.should >= 1
  end
  
  it "should return a string no bigger than the given size" do
    @article.desc(255).size.should <= 255
  end
  
  it "should pull from the fulltext if the description field is blank" do
    @article.description = ''
    @article.desc(255).size.should >= 1
  end
end

describe Article, "when passed short_version" do
  before(:each) do
    @article = Factory.build(:article)
  end
  
  it "should return a non-empty string" do
    @article.short_version.size.should >= 1
  end
  
  it "should return a string no bigger than the given size" do
    @article.short_version(50).size.should <= 50
  end
end

describe Article, "when passed deactivate" do
  before(:each) do
    @article = Factory.create(:article)
  end
  
  it "should mark unread as false" do
    @article.deactivate
    @article.active.should == false
  end
end

describe Article, "when passed mark_as_read" do
  before(:each) do
    @article = Factory.create(:article)
  end
  
  it "should mark unread as false" do
    @article.mark_as_read
    @article.unread.should == false
  end
end

describe Article, "when passed destroy_image" do
  before(:all) do
    @article = Factory.create(:article)
  end
  
  it "should return true if there is no associated image" do
    @article.destroy_image.should == true
  end
  
  it "should delete the associated image if it does exist" do
    @image = Factory.create(:image)  
    @article.image.should_not be_nil # ensure the associated image exists
    @article.destroy_image
    @article.image.should be_nil
  end
end