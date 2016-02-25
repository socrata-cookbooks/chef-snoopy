# Encoding: UTF-8
#
# Cookbook Name:: snoopy
# Library:: provider_snoopy_service
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
    # A Chef provider for the Snoopy service (aka LD preload config).
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SnoopyService < LWRPBase
      use_inline_resources

      provides(:snoopy_service) if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Set Snoopy up in the linker config.
      #
      action :enable do
        file '/etc/ld.so.preload' do
          content lazy { ld_so_preload(:add) }
        end
      end

      #
      # Remove Snoopy from the linker config.
      #
      action :disable do
        file '/etc/ld.so.preload' do
          content lazy { ld_so_preload(:remove) }
        end
      end

      #
      # Perform an action against the ld.so.preload file. Other applications
      # may own libs in this file, so we can't assume Chef's entire ownership
      # of it. This method should only ever be called from within a lazy{}
      # block so it's not evaluated until converge time.
      #
      # @param do_action [Symbol] an :add or :remove action to perform
      #
      # @return String the desired contents of /etc/ld.so.preload
      def ld_so_preload(do_action)
        f = '/etc/ld.so.preload'
        libs = ::File.exist?(f) ? ::File.open(f).read.split : []
        case do_action
        when :add
          (libs << '/lib/libsnoopy.so').uniq.join("\n")
        when :remove
          libs.delete_if { |l| l == '/lib/libsnoopy.so' }.join("\n")
        else
          raise(Chef::Exceptions::UnsupportedAction, do_action)
        end
      end
    end
  end
end
