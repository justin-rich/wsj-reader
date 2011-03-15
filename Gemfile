source 'http://rubygems.org/'
gem "sinatra", :git => "git://github.com/sinatra/sinatra.git"

gem "unicorn",  "~>2.0.1"
gem "rack"
gem "racksh"

gem "mysql"

do_gems_version   = "0.10.3"
gem "data_objects", do_gems_version
gem "do_mysql", do_gems_version # If using another database, replace this

dm_gems_version   = "1.0.2"
gem "datamapper", dm_gems_version         
gem "dm-core", dm_gems_version
gem 'dm-mysql-adapter', dm_gems_version
gem "dm-aggregates", dm_gems_version   
gem "dm-migrations", dm_gems_version   
gem "dm-timestamps", dm_gems_version   
gem "dm-types", dm_gems_version        
gem "dm-validations", dm_gems_version  
gem "dm-serializer", dm_gems_version
gem 'dm-factory_girl', "1.2.3", :require => "factory_girl"

#gem "factory_girl"
gem "hpricot"
gem "chardet", :require => "UniversalDetector"
gem "yard", "0.5.4"

group :test do
  gem "rspec", "~> 2.0"
  gem "cucumber", "~> 0.10"  
  gem "rcov"
  gem "autotest"
  gem "autotest-fsevent"  
  gem "autotest-growl"    
  gem "rack-test"
end

gem "activesupport", "2.3.5", :require => "active_support"

