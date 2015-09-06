# Milestoner

[![Gem Version](https://badge.fury.io/rb/milestoner.svg)](http://badge.fury.io/rb/milestoner)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/milestoner.svg)](https://codeclimate.com/github/bkuhlmann/milestoner)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/milestoner/coverage.svg)](https://codeclimate.com/github/bkuhlmann/milestoner)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/milestoner.svg)](https://gemnasium.com/bkuhlmann/milestoner)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/milestoner.svg)](http://travis-ci.org/bkuhlmann/milestoner)

A tool for automating and releasing Git repository milestones.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Features

- Provides [Semantic Versioning](http://semver.org) for Git repositories in the form of `v<major>.<minor>.</maintenance>` tags.
  Example: `v0.1.0`.
- Provides optional support for signing tags using GPG signing key.
- Automatically includes commits since last tag (or HEAD if no tags exist) within each tag message.

# Requirements

0. A UNIX-based system.
0. [MRI 2.x.x](http://www.ruby-lang.org).
0. [GnuPG](https://www.gnupg.org).

# Setup

For a secure install, type the following (recommended):

    gem cert --add <(curl -Ls http://www.my-website.com/gem-public.pem)
    gem install milestoner --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install milestoner

# Usage

From the command line, type: milestoner help

    milestoner -h, [--help=HELP]  # Show this message or get help for a command.
    milestoner -t, [--tag=TAG]    # Tag repository with new version.
    milestoner -v, [--version]    # Show version.

For more gem creation options, type: milestoner help tag

    -s, [--sign], [--no-sign]  # Sign tag with GPG key.

# Tests

To test, run:

    bundle exec spec

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible public API enhancements and/or bug fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2015 [Alchemists](https://www.alchemists.io).
Read the [LICENSE](LICENSE.md) for details.

# History

Read the [CHANGELOG](CHANGELOG.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at [Alchemists](https://www.alchemists.io).
