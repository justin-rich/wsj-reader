module Merb
  module CategoriesHelper
    def whats_news_print(article)
      parts = article.desc(155).split(" ")
      bolded_parts = parts.slice(0, 4) 
      unbolded_parts = parts - bolded_parts      
      "&#9744; <a href=\"/articles/#{article.id}\"> <b>" + bolded_parts.join(" ") + "</b> " + unbolded_parts.join(" ") + "</a>"
    end
  end
end # Merb