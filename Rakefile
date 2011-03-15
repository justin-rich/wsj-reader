# Initialize app
task :init do
  require 'init'
end

# Can be called from tasks to protect dangerous rake tasks
task :protect do
  if ((ENV['RACK_ENV'] == 'production') && (ENV['FORCE'] != 'true'))
    puts "You must pass FORCE=true to run this in production mode"
    exit(1)
  end
end

# Load custom tasks
Dir["tasks/*.rake"].each {|rake| import rake}