# Milestoner

[![Gem Version](https://badge.fury.io/rb/milestoner.svg)](http://badge.fury.io/rb/milestoner)
[![Code Climate Maintainability](https://api.codeclimate.com/v1/badges/4cf2547433410a9c7150/maintainability)](https://codeclimate.com/github/bkuhlmann/milestoner/maintainability)
[![Code Climate Test Coverage](https://api.codeclimate.com/v1/badges/4cf2547433410a9c7150/test_coverage)](https://codeclimate.com/github/bkuhlmann/milestoner/test_coverage)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/milestoner.svg)](https://gemnasium.com/bkuhlmann/milestoner)
[![Circle CI Status](https://circleci.com/gh/bkuhlmann/milestoner.svg?style=svg)](https://circleci.com/gh/bkuhlmann/milestoner)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

A command line interface for releasing Git repository milestones.

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Features](#features)
  - [Screencasts](#screencasts)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Usage](#usage)
    - [Command Line Interface (CLI)](#command-line-interface-cli)
    - [Customization](#customization)
  - [Security](#security)
  - [Tests](#tests)
  - [Versioning](#versioning)
  - [Code of Conduct](#code-of-conduct)
  - [Contributions](#contributions)
  - [License](#license)
  - [History](#history)
  - [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Features

- Uses [Versionaire](https://github.com/bkuhlmann/versionaire) for
  [Semantic Versioning](http://semver.org).
    - Format: `v<major>.<minor>.<maintenance>`.
    - Example: `v0.1.0`.
- Ensures Git commits since last tag (or initialization of repository) are included within each Git
  tag message.
- Ensures Git commit messages are grouped by prefix, in order defined, for each Git tag message.
  Defaults (can be customized):
    - Fixed
    - Added
    - Updated
    - Removed
    - Refactored
- Ensures Git commit merge messages are excluded within each Git tag message.
- Ensures Git commit messages are alphabetically sorted within each Git tag message.
- Ensures duplicate Git commit messages are removed (if any) within each Git tag message.
- Ensures Git commit messages are sanitized by removing extra spaces and `[ci skip]` text within
  each Git tag message.
- Provides optional security for signing Git tags with [GnuPG](https://www.gnupg.org) signing key.

## Screencasts

[![asciicast](https://asciinema.org/a/91752.png)](https://asciinema.org/a/91752)

## Requirements

0. A UNIX-based system.
0. [Ruby 2.4.x](https://www.ruby-lang.org).
0. [GnuPG](https://www.gnupg.org).

## Setup

For a secure install, type the following (recommended):

    gem cert --add <(curl --location --silent https://www.alchemists.io/gem-public.pem)
    gem install milestoner --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification
while allowing the installation of unsigned dependencies since they are beyond the scope of this
gem.

For an insecure install, type the following (not recommended):

    gem install milestoner

## Usage

### Command Line Interface (CLI)

From the command line, type: `milestoner help`

    milestoner -C, [--commits]          # Show commits for next milestone.
    milestoner -P, [--publish=VERSION]  # Tag and push milestone to remote repository.
    milestoner -c, [--config]           # Manage gem configuration.
    milestoner -h, [--help=COMMAND]     # Show this message or get help for a command.
    milestoner -p, [--push]             # Push local tag to remote repository.
    milestoner -t, [--tag=VERSION]      # Tag local repository with new version.
    milestoner -v, [--version]          # Show gem version.

For config options, type: `milestoner help --config`

    -e, [--edit], [--no-edit]  # Edit gem configuration.
    -i, [--info], [--no-info]  # Print gem configuration info.

For tag options, type: `milestoner help --tag`

    -s, [--sign], [--no-sign]  # Sign tag with GPG key.

For publish options, type: `milestoner help --publish`

    -s, [--sign], [--no-sign]  # Sign tag with GPG key.

When using Milestoner, the `--publish` command is intended to be the only command necessary for
publishing a new release as it handles all of the steps necessary for tagging and pushing a new
milestone. Should individual steps be needed, then the `--tag` and `--push` options are available.

### Customization

This gem can be configured via a global configuration:

    ~/.config/milestoner/configuration.yml

It can also be configured via [XDG environment variables](https://github.com/bkuhlmann/runcom#xdg)
as provided by the [Runcom](https://github.com/bkuhlmann/runcom) gem.

The default configuration is as follows:

    :version: "0.1.0"
    :git_commit_prefixes:
      - Fixed
      - Added
      - Updated
      - Removed
      - Refactored
    :git_tag_sign: false

Feel free to take this default configuration, modify, and save as your own custom
`configuration.yml`.

The `configuration.yml` file can be configured as follows:

- `version`: Useful if desired to have the current version checked into source code per project. The
  version, if set, will be used to tag the repository. If the version is a duplicate, an error will
  be thrown. When supplying a version, it *must* be semantic: `<major>.<minor>.<maintenance>`.
  Example: `0.1.0`.
- `git_commit_prefixes`: Should the default prefixes not be desired, you can define Git commit
  prefixes that match your style. *NOTE: Prefix order is important with the first prefix defined
  taking precedence over the second and so forth.* Special characters are allowed for prefixes but
  should be enclosed in quotes if used. To disable prefix usage completely, use an empty array.
  Example: `:git_commit_prefixes: []`.
- `git_tag_sign`: Defaults to `false` but can be enabled by setting to `true`. When enabled, a Git
  tag will require GPG signing for enhanced security and include a signed signature as part of the
  Git tag. This is useful for public milestones where the author of a milestone can be verified to
  ensure milestone integrity/security.

## Security

To securely sign your Git tags, install and configure [GPG](https://www.gnupg.org):

    brew install gpg
    gpg --gen-key

When creating your GPG key, choose these settings:

- Key kind: RSA and RSA (default)
- Key size: 4096
- Key validity: 0
- Real Name: `<your name>`
- Email: `<your email>`
- Passphrase: `<your passphrase>`

To obtain your key, run the following and take the part after the forward slash:

    gpg --list-keys | grep pub

Add your key to your global Git configuration in the `[user]` section. Example:

    [user]
      signingkey = <your GPG key>

Now, when publishing a new milestone (i.e. `milestoner --publish <version> --sign`), signing of your
Git tag will happen automatically. You will be prompted for the GPG Passphrase each time but that is
to be expected.

## Tests

To test, run:

    bundle exec spec

## Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright (c) 2015 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

## History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

## Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
