# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe :provider_mapping do
  let(:chef_version) { nil }
  let(:platform) { nil }
  let(:resource) { nil }
  let(:provider) do
    Chef::Platform.find_provider(
      platform[:platform],
      platform[:version],
      Chef::Resource::Snoopy.new('default', nil)
    )
  end

  before(:each) do
    Chef::VERSION.replace(chef_version) unless chef_version.nil?
  end

  shared_examples_for 'Chef 12' do
    it 'does not set any other providers' do
      expect(Chef::Platform).to_not receive(:set)
      load(File.expand_path('../../../libraries/provider_mapping.rb',
                            __FILE__))
    end
  end

  context 'Ubuntu' do
    let(:platform) { { platform: 'ubuntu', version: '14.04' } }

    context 'Chef 12' do
      let(:chef_version) { '12.4.1' }

      it_behaves_like 'Chef 12'
    end

    context 'Chef 11' do
      let(:chef_version) { '11.16.4' }

      it 'sets up old-style provider mappings' do
        allow(Chef::Log).to receive(:warn)
        expect(Chef::Platform).to receive(:set).at_least(1).times
          .and_call_original
        load(File.expand_path('../../../libraries/provider_mapping.rb',
                              __FILE__))
        expect(provider).to eq(Chef::Provider::Snoopy)
      end
    end
  end
end
