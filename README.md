Snoopy Cookbook
===============
[![Cookbook Version](https://img.shields.io/cookbook/v/snoopy.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/snoopy.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/snoopy.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/snoopy.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/snoopy
[travis]: https://travis-ci.org/socrata-cookbooks/snoopy
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/snoopy
[coveralls]: https://coveralls.io/r/socrata-cookbooks/snoopy

A Chef cookbook for [Snoopy Logger](https://github.com/a2o/snoopy).

Because there is no Snoopy package easily available for RHEL, and the one for
Ubuntu 14.04 is extremely old, this cookbook uses newer packages that we
[build](https://github.com/socrata-platform/snoopy-build) ourselves and store
in PackageCloud.io.

Requirements
============

This cookbook is currently compatible with and tested against Ubuntu 10.04,
12.04, 14.04, and 15.10; and RHEL (or CentOS, etc.) 7 and 6.

It intentionally maintains backward compatibility with Chef 11, at the expense
of some minor additional complexity.

Usage
=====

Either add the `snoopy` default recipe to your node's run_list, or make use of
the included Chef resources in a recipe of your own.

Recipes
=======

***default***

Set up the proper package repository; install Snoopy; configure it; and enable
it on the system, all in an attribute-driven fashion.

Attributes
==========

***default***

    default['snoopy']['app']['source'] = nil

An optional custom file path or URL to a Snoopy package to install.

    default['snoopy']['service']['enabled'] = true

Can be overridden to leave Snoopy installed but not running.

    default['snoopy']['config'] = nil

An optional hash of config overrides, in underscore format, to pass into
Snoopy's config.

Resources
=========

***snoopy***

A parent resource that couples an app, config, and service resource together.

Syntax:

    snoopy 'default' do
        source '/tmp/snoopy.deb'
        config filterchain: 'exclude_uid:0'
        action :create
    end

Actions:

| Action    | Description                           |
|-----------|---------------------------------------|
| `:create` | Install, configure, and enable Snoopy |
| `:remove` | Disable and uninstall Snoopy          |

Attributes:

| Attribute | Default    | Description                                 |
|-----------|------------|---------------------------------------------|
| source    | `nil`      | An optional package source path/URL         |
| config    | `nil`      | An optional hash of configuration overrides |
| action    | `:install` | Action(s) to perform                        |

***snoopy_app***

The resource that manages installation of the Snoopy repo and packages.

Syntax:

    snoopy_app 'default' do
        source '/tmp/snoopy.deb'
        action :install
    end

Actions:

| Action     | Description                                       |
|------------|---------------------------------------------------|
| `:install` | Enable the custom package repo and install Snoopy |
| `:remove`  | Uninstall Snoopy and disable the package repo     |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| source    | `nil`      | An optional package source path/URL |
| action    | `:install` | Action(s) to perform                |

***snoopy_config***

The child resource for handling Snoopy's configuration.

Syntax:

    snoopy_config 'default' do
        config { some_option_key: 'some_option_value' }
        action :install
    end

Actions:

| Action    | Description       |
|-----------|-------------------|
| `:create` | Render the config |
| `:remove` | Delete the config |

Attributes:

| Attribute | Default             | Description                       |
|-----------|---------------------|-----------------------------------|
| config    | `nil`               | Optional hash of config overrides |
| action    | `:install`          | Action(s) to perform              |

***snoopy_service***

The child resource for handling enabling and disabling Snoopy via LD_PRELOAD.

Syntax:

    snoopy_service 'default' do
        action :enable
    end

Actions:

| Action     | Description    |
|------------|----------------|
| `:enable`  | Enable Snoopy  |
| `:disable` | Disable Snoopy |

Attributes:

| Attribute | Default   | Description          |
|-----------|-----------|----------------------|
| action    | `:enable` | Action(s) to perform |

Providers
=========

***Chef::Provider::Snoopy***

The main provider for the parent `snoopy` resource.

***Chef::Provider::SnoopyApp***

Provider with shared, platform-agnostic package management logic.

***Chef::Provider::SnoopyApp::Debian***

Ubuntu implementation of `Chef::Provider::SnoopyApp`.

***Chef::Provider::SnoopyApp::Rhel***

RHEL (and RHEL-alike) implementation of `Chef::Provider::SnoopyApp`.

***Chef::Provider::SnoopyConfig***

The platform-agnostic provider for managing Snoopy's configuration.

***Chef::Provider::SnoopyService***

The platform-agnostic provider for enable and disabling Snoopy logging.

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

Copyright 2015-2016, Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
