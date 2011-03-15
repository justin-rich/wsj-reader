require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Article do
  
  it "should be valid with valid attributes" do
    @article = Factory.build(:article)
    @article.should be_valid
  end
  
  it "should be invalid without a URL" do
    @article = Factory.build(:article, :url => nil)    
    @article.should_not be_valid
  end
  
  it "should be invalid with an invalid URL" do
    @article = Factory.build(:article, :url => "not_a_url")        
    @article.should_not be_valid
  end
  
  it "should be invalid without a title" do
    @article = Factory.build(:article, :title => nil)            
    @article.should_not be_valid
  end
  
  it "should be valid with or without a subtitle" do
    @article = Factory.build(:article, :subtitle => nil)                
    @article.should be_valid
  end
    
  it "should be valid with or without an author" do
    @article = Factory.build(:article, :author => nil)                    
    @article.should be_valid
  end
  
  it "should be invalid without a pubDate" do
    @article = Factory.build(:article, :pub_date => nil)                        
    @article.should_not be_valid
  end
  
  it "should be invalid without fulltext" do
    @article = Factory.build(:article, :fulltext => nil)                            
    @article.should_not be_valid
  end
  
  it "should be valid with or without a description" do
    @article = Factory.build(:article, :description => nil)                                
    @article.should be_valid
  end
  
  it "should be invalid without a priority" do
    @article = Factory.build(:article, :priority => nil)                                    
    @article.should_not be_valid
  end
  
  it "should be valid with or without active set" do
    @article = Factory.build(:article, :active => nil)                                        
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