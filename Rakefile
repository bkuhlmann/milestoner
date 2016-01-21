# require "gemsmith/rake/setup"
require "bundler/gem_tasks"

Dir.glob("lib/tasks/*.rake").each { |file| load file }

task default: %w(spec rubocop)
