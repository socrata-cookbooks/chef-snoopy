# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_snoopy_app_debian
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
require_relative 'provider_snoopy_app'

class Chef
  class Provider
    class SnoopyApp < LWRPBase
      # A Chef provider for the Snoopy Logger application packages for Debian.
      #
      # @author Jonathan Hartman <jonathan.hartman@socrata.com>
      class Debian < SnoopyApp
        provides(:snoopy_app, platform_family: 'debian') if defined?(provides)

        #
        # Set up the PackageCloud .deb repo before trying to install Snoopy.
        #
        # (see Chef::Provider::SnoopyApp#install!)
        #
        def install!
          unless new_resource.source
            packagecloud_repo('socrata-platform/snoopy') { type 'deb' }
          end
          super
        end

        #
        # Remove the PackageCloud .deb repo after uninstalling Snoopy.
        #
        # (see Chef::Provider::SnoopyApp#remove!)
        #
        def remove!
          super
          # For lack of a :remove action in the packagecloud cookbook
          file('/etc/apt/sources.list.d/socrata-platform_snoopy.list') do
            action :delete
          end
        end
      end
    end
  end
end
