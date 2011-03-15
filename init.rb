# Include required gems
%w{
  rubygems bundler
}.each {|req| require req }

Bundler.setup

%w{
  sinatra datamapper hpricot iconv timeout yaml
}.each {|req| require req }

# Require custom libraries and application files
Dir["lib/**/*.rb"].sort.each {|req| require req}

Settings = Configurator.load

# Global Logger
#Log = Logger.new(STDOUT)
#DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, Settings.db.uri)

# Require models and sinatra apps
Dir["app/models/**/*.rb"].sort.each {|req| require req}
Dir["app/apps/*.rb"].sort.each {|req| require req}

# Globals
BLACKLISTED_TITLES = YAML::load(File.open("#{Settings.root}/app/importers/blacklisted_titles.yml"))

