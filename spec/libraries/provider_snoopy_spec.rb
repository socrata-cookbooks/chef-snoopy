# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_snoopy'
require_relative '../../libraries/resource_snoopy'

describe Chef::Provider::Snoopy do
  let(:name) { 'default' }
  let(:source) { nil }
  let(:config) { nil }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    r = Chef::Resource::Snoopy.new(name, run_context)
    r.source(source) unless source.nil?
    r.config(config) unless config.nil?
    r
  end
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
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_create' do
    before(:each) do
      [:snoopy_app, :snoopy_config, :snoopy_service].each do |r|
        allow_any_instance_of(described_class).to receive(r)
      end
    end

    shared_examples_for 'any attribute set' do
      it 'installs Snoopy with the right source' do
        p = provider
        expect(p).to receive(:snoopy_app).with(name).and_yield
        expect(p).to receive(:source).with(source)
        p.action_create
      end

      it 'configures Snoopy with the right config' do
        p = provider
        expect(p).to receive(:snoopy_config).with(name).and_yield
        expect(p).to receive(:config).with(config)
        p.action_create
      end

      it 'enables Snoopy' do
        p = provider
        expect(p).to receive(:snoopy_service).with(name)
        p.action_create
      end
    end

    context 'all default attributes' do
      it_behaves_like 'any attribute set'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/snoopy.pkg' }

      it_behaves_like 'any attribute set'
    end

    context 'a config attribute' do
      let(:config) { { key: 'value' } }

      it_behaves_like 'any attribute set'
    end
  end

  describe '#action_remove' do
    before(:each) do
      [:snoopy_service, :snoopy_config, :snoopy_app].each do |r|
        allow_any_instance_of(described_class).to receive(r)
      end
    end

    it 'disables Snoopy' do
      p = provider
      expect(p).to receive(:snoopy_service).with(name).and_yield
      expect(p).to receive(:action).with(:disable)
      p.action_remove
    end

    it 'removes the Snoopy config' do
      p = provider
      expect(p).to receive(:snoopy_config).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end

    it 'removes the Snoopy package' do
      p = provider
      expect(p).to receive(:snoopy_app).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end
  end
end
