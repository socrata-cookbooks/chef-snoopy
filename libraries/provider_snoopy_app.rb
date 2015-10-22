# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_snoopy_app
#
# Copyright 2015 Socrata, Inc.
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

class Chef
  class Provider
    # A Chef provider for the Snoopy Logger application packages.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SnoopyApp < LWRPBase
      use_inline_resources

      provides(:snoopy_app, platform: 'ubuntu') if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install the Snoopy Logger and set it up in the linker config.
      #
      action :install do
        unless new_resource.source
          packagecloud_repo('socrata-platform/snoopy') { type 'deb' }
        end
        package(new_resource.source || 'snoopy')
      end

      #
      # Uninstall the Snoopy Logger.
      #
      action :remove do
        package('snoopy') { action :remove }
        # For lack of a :remove action in the packagecloud cookbook
        file('/etc/apt/sources.list.d/socrata-platform_snoopy.list') do
          action :delete
        end
      end
    end
  end
end
