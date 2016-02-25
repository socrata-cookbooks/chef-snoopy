# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_mapping
#
# Copyright 2015-2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/version'
require 'chef/platform/provider_mapping'
require_relative 'provider_snoopy'
require_relative 'provider_snoopy_app'
require_relative 'provider_snoopy_app_debian'
require_relative 'provider_snoopy_app_rhel'
require_relative 'provider_snoopy_config'
require_relative 'provider_snoopy_service'

if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12')
  {
    ubuntu: Chef::Provider::SnoopyApp::Debian,
    debian: Chef::Provider::SnoopyApp::Debian,
    redhat: Chef::Provider::SnoopyApp::Rhel,
    centos: Chef::Provider::SnoopyApp::Rhel,
    scientific: Chef::Provider::SnoopyApp::Rhel
  }.each do |f, p|
    Chef::Platform.set(platform: f, resource: :snoopy_app, provider: p)
  end
  {
    snoopy: Chef::Provider::Snoopy,
    snoopy_config: Chef::Provider::SnoopyConfig,
    snoopy_service: Chef::Provider::SnoopyService
  }.each do |r, p|
    Chef::Platform.set(resource: r, provider: p)
  end
end
