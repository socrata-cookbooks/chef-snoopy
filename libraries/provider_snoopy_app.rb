# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_snoopy_app
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

class Chef
  class Provider
    # A parent Chef provider for the Snoopy app for platform-specific providers
    # to inherit from.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SnoopyApp < LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Set up an install action.
      #
      action :install do
        install!
      end

      #
      # Set up a :remove action.
      #
      action :remove do
        remove!
      end

      private

      #
      # Install the Snoopy Logger.
      #
      def install!
        package(new_resource.source || 'snoopy')
      end

      #
      # Uninstall the Snoopy Logger.
      #
      def remove!
        package('snoopy') { action :remove }
      end
    end
  end
end
