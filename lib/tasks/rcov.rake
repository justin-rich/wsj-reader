require 'rake'
require 'spec/rake/spectask'

desc "Run all specs with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ["--exclude", "config,gems,merb,spec"]
end