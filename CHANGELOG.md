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
