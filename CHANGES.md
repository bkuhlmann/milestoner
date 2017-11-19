# v6.3.1 (2017-11-19)

- Updated to Git Cop 1.7.0.
- Updated to Rake 12.3.0.

# v6.3.0 (2017-10-29)

- Added Bundler Audit gem.
- Updated to Rubocop 0.50.0.
- Updated to Rubocop 0.51.0.
- Updated to Ruby 2.4.2.
- Removed Pry State gem.

# v6.2.0 (2017-08-20)

- Fixed issue with Tempfile requirements.
- Added dynamic formatting of RSpec output.
- Updated to Gemsmith 10.2.0.
- Updated to Runcom 1.3.0.

# v6.1.0 (2017-07-16)

- Added Git Cop code quality task.
- Updated CONTRIBUTING documentation.
- Updated GitHub templates.
- Updated README headers.
- Updated command line usage in CLI specs.
- Updated gem dependencies.
- Updated to Awesome Print 1.8.0.
- Updated to Gemsmith 10.0.0.
- Removed Thor+ gem.
- Refactored CLI version/help specs.

# v6.0.0 (2017-06-17)

- Added Circle CI support.
- Updated README usage configuration documenation.
- Updated gem dependencies.
- Updated to Runcom 1.1.0.
- Removed Travis CI support.

# v5.1.0 (2017-05-07)

- Fixed Reek DuplicateMethodCall issue.
- Fixed Travis CI configuration to not update gems.
- Added Git tag support.
- Added Pusher version.
- Added Reek issues to affected objects.
- Added code quality Rake task.
- Added existing local tag check.
- Added passphrase to GPG test script.
- Added version release changes.
- Updated Git test respository configuration.
- Updated Guardfile to always run RSpec with documentation format.
- Updated README semantic versioning order.
- Updated RSpec configuration to output documentation when running.
- Updated RSpec spec helper to enable color output.
- Updated Rubocop configuration.
- Updated Rubocop to import from global configuration.
- Updated contributing documentation.
- Updated signed tag spec to be skipped.
- Updated to Gemsmith 9.0.0.
- Updated to Ruby 2.4.1.
- Removed Code Climate code comment checks.
- Removed Git repository validation.
- Removed Reek TODO file.
- Removed `.bundle` directory from `.gitignore`.
- Removed default version from Tagger.
- Removed deletion of Git hooks for testing purposes.
- Removed shell from pusher.
- Refactored Git tag check.
- Refactored context descriptions.
- Refactored tagger spec context and descriptions.

# v5.0.0 (2017-01-22)

- Updated Rubocop Metrics/LineLength to 100 characters.
- Updated Rubocop Metrics/ParameterLists max to three.
- Updated Travis CI configuration to use latest RubyGems version.
- Updated gemspec to require Ruby 2.4.0 or higher.
- Updated to Rubocop 0.47.
- Updated to Ruby 2.4.0.
- Removed Rubocop Style/Documentation check.

# v4.2.0 (2016-12-18)

- Fixed Rakefile support for RSpec, Reek, Rubocop, and SCSS Lint.
- Added `Gemfile.lock` to `.gitignore`.
- Updated Travis CI configuration to use defaults.
- Updated gem dependencies.
- Updated to Gemsmith 8.2.x.
- Updated to Rake 12.x.x.
- Updated to Rubocop 0.46.x.
- Updated to Ruby 2.3.2.
- Updated to Ruby 2.3.3.

# v4.1.1 (2016-11-13)

- Fixed gem requirements order.

# v4.1.0 (2016-11-13)

- Fixed Ruby pragma.
- Added Code Climate engine support.
- Added Git config support.
- Added Reek support.
- Updated RSpec Git repo shared context syntax.
- Updated `--config` command to use computed path.
- Updated to Code Climate Test Reporter 1.0.0.
- Updated to Gemsmith 8.0.0.
- Removed CLI defaults (using configuration instead).
- Refactored `Git` as `Git::Kit`.
- Refactored source requirements.

# v4.0.0 (2016-11-05)

- Fixed CLI spec RSpec metadata.
- Fixed Rakefile to safely load Gemsmith tasks.
- Fixed Rubocop Style/NumericLiteralPrefix issue.
- Fixed creating signed tag when GPG program is invalid.
- Added Runcom support.
- Added Travis CI random number generation.
- Added batch script for GPG key generation.
- Added frozen string literal pragma.
- Updated CLI command option documentation.
- Updated README versioning documentation.
- Updated RSpec temp directory to use Bundler root path.
- Updated Rubocop PercentLiteralDelimiters and AndOr styles.
- Updated Tagger spec to use GPG key gen batch script.
- Updated gemspec with conservative versions.
- Updated order of local and global configuration information.
- Updated to Gemsmith 7.7.0.
- Updated to RSpec 3.5.0.
- Updated to Rubocop 0.44.
- Updated to Ruby 2.3.1.
- Updated to Thor+ 4.0.0.
- Updated to Versionaire 2.0.0.
- Removed CHANGELOG.md (use CHANGES.md instead).
- Removed Greenletters gem.
- Removed Rake console task.
- Removed `Milestoner::Configuration`.
- Removed `Milestoner::Errors::Version`.
- Removed gemspec description.
- Removed rb-fsevent development dependency from gemspec.
- Removed terminal notifier gems from gemspec.
- Refactored CLI defaults as class method.
- Refactored CLI subject.
- Refactored RSpec spec helper configuration.
- Refactored gemspec to use default security keys.
- Refactored order of local and global methods.
- Refactored tagger implementation.

# v3.0.0 (2016-04-03)

- Fixed CLI specs so pusher is spied upon.
- Added --config, -c command.
- Added Versionaire gem dependency.
- Added bond, wirb, hirb, and awesome_print development dependencies.
- Added failure when Git is unable to push tags to remote repository.
- Added global and local configuration file detection.
- Updated GitHub issue and pull request templates.
- Removed --edit, -e command.
- Removed -c alias (use -C instead).
- Removed `Tagger#destroy`.
- Removed gem label from version information.
- Refactored CLI to use Versionaire version.
- Refactored Git module to class object.
- Refactored Pusher to use shell instead of kernel keyword.
- Refactored Tagger git tag construction.
- Refactored Tagger to use Versionaire version.

# v2.2.0 (2016-03-13)

- Fixed contributing guideline links.
- Added Git aid commit check.
- Added Git tag auto-delete for Git error when publishing.
- Added Git tag create failure when no commits exist.
- Added GitHub issue and pull request templates.
- Added README Screencasts section.
- Added Rubocop Style/SignalException cop style.
- Added tag delete support.
- Updated README secure gem install documentation.
- Updated to Code of Conduct, Version 1.4.0.

# v2.1.0 (2016-01-20)

- Fixed secure gem install issues.
- Added Gemsmith development support.
- Added frozen string literal support to Ruby source.
- Removed frozen string literal from non-Ruby source.

# v2.0.0 (2016-01-17)

- Fixed README URLs to use HTTPS schemes where possible.
- Added GPG security documentation to README.
- Added IRB development console Rake task support.
- Added Ruby 2.3.0 frozen string literal support.
- Updated tagger specs to skip GPG sign spec when on CI.
- Updated to Ruby 2.3.0.
- Removed RSpec default monkey patching behavior.
- Removed Ruby 2.1.x and 2.2.x support.
- Removed verbosity from CLI help command specs.

# v1.2.0 (2015-11-27)

- Fixed failing specs when global config is used.
- Fixed gemspec homepage URL.
- Added Patreon badge to README.
- Added Rubocop Style/StringLiteralsInInterpolation cop.
- Added gemspec version requirements for Thor-related gems.
- Updated Code Climate to run when CI ENV is set.
- Updated Code of Conduct 1.3.0.
- Updated README to use asciinema public URL.
- Updated README with Tocer generated Table of Contents.
- Removed RSpec GPG test output.
- Removed `Milestoner::Configuration.file_name`.
- Removed unnecessary exclusions from .gitignore.

# v1.1.0 (2015-10-01)

- Fixed RSpec example status persistence file path.
- Fixed issue with version format limited to single digits.
- Added carriage return after tag message bodies.
- Updated to Gemsmith 5.6.0.

# v1.0.0 (2015-09-19)

- Fixed Git tag being deleted when publishing.
- Updated Publisher class to accept an optional tagger and pusher.
- Refactored code to use relative namespaces.

# v0.5.0 (2015-09-16)

- Fixed bug when pushing to a non-existent remote repository.
- Fixed git error when attempting to delete a non-existent tag.
- Added Git aid for detecting if remote repository is configured.
- Added a publisher which knows how to tag and push a tag.

# v0.4.0 (2015-09-13)

- Added --edit option for editing gem configuration.
- Added .milestonerrc git_tag_sign setting.
- Added .milestonerrc version setting..
- Added Git error support.
- Added gem configuration error support.
- Added global and local gem configuration and CLI support.
- Updated CLI command descriptions.

# v0.3.0 (2015-09-08)

- Fixed bug where commit messages with backticks were executed.
- Added -c option for showing commits for current milestone.
- Added commit message sanitation support.
- Updated commit message groups to be alpha-sorted.
- Updated tag messages to have duplicate commits removed.

# v0.2.0 (2015-09-07)

- Fixed RSpec Git setup.
- Fixed Travis CI GPG setup.
- Fixed sorting/grouping of Git commit messages.
- Added Git tag deletion support.
- Added Git tag push support.
- Added duplicate tag detection support.
- Added repository publish support.
- Removed commit order spec.

# v0.1.0 (2015-09-06)

- Initial version.
