module Merb
  module CategoriesHelper
    def whats_news_print(article, first=false)
      parts = article.desc(255).split(" ")
      
      bolded_parts = if first
        parts.slice(0, 2).join(" ")        
      else
        parts.slice(0, 4).join(" ")
      end
      
      unbolded_parts =( parts - bolded_parts.split(" ")).join(" ")
      
      bolded_words = if first
        "<span class=\"capital\">" + bolded_parts[0,1] + "</span>" + bolded_parts[1,bolded_parts.size]
      else
        bolded_parts
      end
      
      square = if first
        ""
      else
        "&#9744;"
      end
      
      square + "<a href=\"/articles/#{article.id}\"> <b>" + bolded_words + "</b> " + unbolded_parts + "</a>"      
    end
  end
end # Merb