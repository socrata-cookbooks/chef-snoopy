# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: resource_snoopy
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A parent Chef resource for the Snoopy app, config, and service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Snoopy < LWRPBase
      self.resource_name = :snoopy
      actions :create, :remove
      default_action :create

      #
      # Attribute to allow an override of the default package source path/URL.
      #
      attribute :source, kind_of: String, default: nil

      #
      # Attribute to allow enabling/disabling of the Snoopy service.
      #
      attribute :enabled, kind_of: [TrueClass, FalseClass], default: true

      #
      # Attribute to allow a set of configuration overrides.
      #
      attribute :config, kind_of: Hash, default: nil
    end
  end
end
