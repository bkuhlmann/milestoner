# frozen_string_literal: true

require "rspec/core/shared_context"

module RSpec
  module Kit
    # Adds Git repository support to specs enabled with the :git_repo metadata key.
    module GitRepoContext
      extend RSpec::Core::SharedContext
      let(:git_repo_dir) { File.join temp_dir, "tester" }
      let(:git_user_name) { "Testy Tester" }
      let(:git_user_email) { "tester@example.com" }
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Kit::GitRepoContext

  config.before do |example|
    if example.metadata[:git_repo]
      FileUtils.mkdir_p git_repo_dir

      Dir.chdir(git_repo_dir) do
        FileUtils.touch "one.txt"
        FileUtils.touch "two.txt"
        FileUtils.touch "three.txt"
        `git init`
        `rm -rf .git/hooks`
        `git config --local user.name "#{git_user_name}"`
        `git config --local user.email "#{git_user_email}"`
        `git config remote.origin.url git@github.com:example/example.git`
        `git add --all .`
        `git commit --all --message "Added dummy files."`
      end
    end
  end

  config.after do |example|
    FileUtils.rm_rf(git_repo_dir) if example.metadata[:git_repo]
  end
end
