class WSJ::ArticlesApp < WSJ::Base
  
  configure do
    set :views, "app/views/articles"
  end
  
  helpers do

  end
  
  get '/' do
    @category = Category.first(:id => params[:category_id])      
    
    unless is_mobile_device?
      @article = @category.top_story
      redirect "/news/#{@article.id}"
      return
    else
      @articles = @category.articles(:active => true, :order => [ :priority ])
      herb :index
    end
  end
  
  get '/:id' do
    @article = Article.get(params[:id])
    @category = @article.category                                  
    raise NotFound unless @article
    find_next_article
    find_prev_article
    @article.mark_as_read
    herb :show
  end
  
  private
  
  def find_neighbor_article(offset)
    articles = @category.articles(:active => true, :order => [ :priority ])
      
    @index = articles.index(@article)

    unless (@index + offset < 0) || (@index + offset > articles.size)
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
  
end