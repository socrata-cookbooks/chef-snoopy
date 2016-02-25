# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_snoopy
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

require 'chef/exceptions'
require 'chef/provider/lwrp_base'
require_relative 'resource_snoopy_app'
require_relative 'resource_snoopy_config'
require_relative 'resource_snoopy_service'

class Chef
  class Provider
    # A parent Chef provider for the Snoopy app, config, and service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Snoopy < LWRPBase
      use_inline_resources

      provides :snoopy if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install Snoopy, configure it, and enable it.
      #
      action :create do
        snoopy_app(new_resource.name) { source new_resource.source }
        snoopy_config(new_resource.name) { config new_resource.config }
        snoopy_service new_resource.name do
          action :disable unless new_resource.enabled
        end
      end

      #
      # Disable Snoopy logging, delete the config, and remove the package.
      #
      action :remove do
        snoopy_service(new_resource.name) { action :disable }
        snoopy_config(new_resource.name) { action :remove }
        snoopy_app(new_resource.name) { action :remove }
      end
    end
  end
end
