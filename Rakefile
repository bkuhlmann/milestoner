require "gemsmith/rake/setup"
Dir.glob("lib/milestoner/tasks/*.rake").each { |file| load file }

task default: %w(spec rubocop)
