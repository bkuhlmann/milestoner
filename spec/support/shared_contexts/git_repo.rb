# frozen_string_literal: true

RSpec.shared_context "Git Repository", :git_repo do
  let(:temp_dir) { File.join Bundler.root, "tmp", "rspec" }
  let(:git_repo_dir) { File.join temp_dir, "repo" }
  let(:git_user_name) { "Testy Tester" }
  let(:git_user_email) { "tester@example.com" }

  around do |example|
    FileUtils.mkdir_p git_repo_dir

    Dir.chdir(git_repo_dir) do
      FileUtils.touch "one.txt"
      FileUtils.touch "two.txt"
      FileUtils.touch "three.txt"
      `git init`
      `git config user.name "#{git_user_name}"`
      `git config user.email "#{git_user_email}"`
      `git config core.hooksPath /dev/null`
      `git config remote.origin.url git@github.com:example/example.git`
      `git add --all .`
      `git commit --all --message "Added dummy files."`
    end

    example.run

    FileUtils.rm_rf temp_dir
  end
end
