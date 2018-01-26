require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# https://ernie.io/2014/02/05/7-lines-every-gems-rakefile-should-have/
desc "Open an irb session preloaded with this library"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'active_record'
  require 'acts_as_mergeable'

  # give access to the "reload!" function in the console... to reload.. :)
  # thanks to https://stackoverflow.com/a/23677820/4330954
  def reload!
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/acts_as_mergeable\// }
    files.each { |file| load file }
  end

  ARGV.clear
  IRB.start
end
