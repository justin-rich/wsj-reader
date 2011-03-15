require 'yaml'
namespace :seed do
  ##
  # Loads the categories and feeds for the app
  #
  # @todo move to rake task
  #
  # @return [Article, nil] the highest priority active article for the category, 
  #   or nil if the category has no article
  desc "Loads news source data from config/feeds.yml" 
  task :all => :init do
    YAML::load(File.open("#{Settings.root}/config/feeds.yml")).each do |category|
      c = Category.create(:name => category["name"], :display => category["display"])

      next unless category["feeds"]

      category["feeds"].each do |feed|
        attrs = {:name => feed["name"], :url => feed["url"], :category => c}

        case feed["type"]
        when "PageOne"                
          PageOneageOne.create(attrs)
        when "Opinion"
          FeedOpinion.create(attrs)
        when "MoneyInvesting"
          FeedMoneyInvesting.create(attrs)                    
        else
          RssFeed.create(attrs)          
        end
      end
    end    
  end
end
