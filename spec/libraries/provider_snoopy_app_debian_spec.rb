# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_snoopy_app_debian'
require_relative '../../libraries/resource_snoopy_app'

describe Chef::Provider::SnoopyApp::Debian do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SnoopyApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'CentOS' do
      let(:platform) { { platform: 'centos', version: '7.0' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#install!' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    before(:each) do
      [:packagecloud_repo, :package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    context 'no custom source (default)' do
      let(:source) { nil }

      it 'adds the Snoopy repository' do
        p = provider
        expect(p).to receive(:packagecloud_repo).with('socrata-platform/snoopy')
          .and_yield
        expect(p).to receive(:type).with('deb')
        p.send(:install!)
      end

      it 'installs the default Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('snoopy')
        p.send(:install!)
      end
    end

    context 'a custom source' do
      let(:source) { '/tmp/snoopy' }

      it 'does not set up the Snoopy repository' do
        p = provider
        expect(p).to_not receive(:packagecloud_repo)
        p.send(:install!)
      end

      it 'installs the custom Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('/tmp/snoopy')
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    before(:each) do
      [:file, :package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'removes the Snoopy package' do
      p = provider
      expect(p).to receive(:package).with('snoopy').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end

    it 'deletes the Snoopy repository config' do
      p = provider
      allow(p).to receive(:file).and_call_original
      f = '/etc/apt/sources.list.d/socrata-platform_snoopy.list'
      expect(p).to receive(:file).with(f).and_yield
      expect(p).to receive(:action).with(:delete)
      p.send(:remove!)
    end
  end
end
