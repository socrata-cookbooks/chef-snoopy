Snoopy Cookbook
===============
[![Cookbook Version](https://img.shields.io/cookbook/v/snoopy.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/chef-snoopy.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/chef-snoopy.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/chef-snoopy.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/snoopy
[travis]: https://travis-ci.org/socrata-cookbooks/chef-snoopy
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/chef-snoopy
[coveralls]: https://coveralls.io/r/socrata-cookbooks/chef-snoopy

A Chef cookbook for [Snoopy Logger](https://github.com/a2o/snoopy).

Because there is no Snoopy package easily available for RHEL, and the one for
Ubuntu 14.04 is extremely old, this cookbook uses newer packages that we
[build](https://github.com/socrata-platform/snoopy-build) ourselves and store
in PackageCloud.io.

Requirements
============

This cookbook currently supports Ubuntu only. It intentionally maintains
backward compatibility with Chef 11, at the expense of some minor additional
complexity.

Usage
=====

Either add the `snoopy` default recipe to your node's run_list, or make use of
the included Chef resources in a recipe of your own.

Recipes
=======

***default***

Install Snoopy Logger in an attribute-driven fashion.

Attributes
==========

***default***

    default['snoopy']['app']['source'] = nil

An optional custom file path or URL to a Snoopy package to install.

Resources
=========

***snoopy***

The main resource for handling the Snoopy Logger.

Syntax:

    snoopy 'default' do
        source '/tmp/snoopy.deb'
        action :install
    end

Actions:

| Action     | Description      |
|------------|------------------|
| `:install` | Install Snoopy   |
| `:remove`  | Uninstall Snoopy |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| source    | `nil`      | An optional package source path/URL |
| action    | `:install` | Action(s) to perform                |

Providers
=========

***Chef::Provider::Snoopy***

The main provider for managing Snoopy.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2015 Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
