desc "Open IRB console for gem development environment"
task :console do
  require "irb"
  require "milestoner"
  ARGV.clear
  IRB.start
end
