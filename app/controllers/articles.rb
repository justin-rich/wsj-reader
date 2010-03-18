class Articles < Application
  
  def index
    @articles = if params[:query].blank?
      @category = Category.first(:id => params[:category_id])
      raise NotFound unless @category
      @category.articles(:active => true, :order => [ :rss_feed_id, :priority ])
    else
      Article.search(:title => params[:query], :author => params[:query], :fulltext => params[:query])
    end
    
    display @articles
  end

  def show(id)
    @article = Article.get(id)
    @category = @article.category
    raise NotFound unless @article
    find_next_article
    find_prev_article
    @article.mark_as_read
    display @article, :show
  end
  
  def today
    @category = Category.first(:name => "Today's Paper")
    raise NotFound unless @category
    article = @category.top_story
    raise NotFound unless article
    redirect("/articles/#{article.id}")
  end
  
  private
  
  def find_neighbor_article(offset)
   articles = if params[:query].blank?
      @category.articles(:active => true, :order => [ :rss_feed_id, :priority ])
    else
      Article.search(:title => params[:query], :author => params[:query], :fulltext => params[:query])
    end
      
    @index = articles.index(@article)
    size = articles.size
    
    unless (@index + offset < 0) || (@index + offset > size)
      articles[@index+offset]
    else
      nil
    end
  end
  
  def find_next_article
    @next_article = find_neighbor_article(1)
  end
  
  def find_prev_article
    @prev_article = find_neighbor_article(-1)    
  end
end # Articles
