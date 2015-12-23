# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_snoopy_app'
require_relative '../../libraries/resource_snoopy_app'

describe Chef::Provider::SnoopyApp do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SnoopyApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    it 'calls the install! method' do
      p = provider
      expect(p).to receive(:install!)
      p.action_install
    end
  end

  describe '#action_remove' do
    it 'calls the remove! method' do
      p = provider
      expect(p).to receive(:remove!)
      p.action_remove
    end
  end

  describe '#install!' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    context 'no custom source (default)' do
      let(:source) { nil }

      it 'installs the default Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('snoopy')
        p.send(:install!)
      end
    end

    context 'a custom source' do
      let(:source) { '/tmp/snoopy' }

      it 'installs the custom Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('/tmp/snoopy')
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    it 'removes the Snoopy package' do
      p = provider
      expect(p).to receive(:package).with('snoopy').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
