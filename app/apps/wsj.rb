class WSJ::FrontPageApp < WSJ::Base
  
  configure do
    set :views, "app/views/front_page"
  end
  
  helpers do
  end
  
  get '/' do
    @categories = Category.all(:display => true)
    herb :index
  end
  
  get '/today' do
    @category = Category.first(:name => "Today's Paper")    
    @article = @category.top_story

    redirect("/news/#{@article.id}")
  end
end
