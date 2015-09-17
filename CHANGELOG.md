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
