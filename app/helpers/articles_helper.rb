module Merb
  module ArticlesHelper
    def blah(article)
      if params[:query].blank
        resource(article)        
      else
        resource(article, {:query => params[:query]})                
      end
    end
  end
end # Merb