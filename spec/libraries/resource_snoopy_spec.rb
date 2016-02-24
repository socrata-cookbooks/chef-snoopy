# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_snoopy'

describe Chef::Resource::Snoopy do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:snoopy)
    end

    it 'sets the correct supported actions' do
      expect(resource.allowed_actions).to eq([:nothing, :create, :remove])
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:create])
    end
  end

  describe '#source' do
    let(:source) { nil }
    let(:resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    context 'no override' do
      let(:source) { nil }

      it 'defaults to nil' do
        expect(resource.source).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:source) { 'http://example.com/pkg.pkg' }

      it 'returns the override' do
        expect(resource.source).to eq(source)
      end
    end

    context 'an invalid override' do
      let(:source) { :thing }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#enabled' do
    let(:enabled) { nil }
    let(:resource) do
      r = super()
      r.enabled(enabled) unless enabled.nil?
      r
    end

    context 'no override' do
      let(:enabled) { nil }

      it 'defaults to true' do
        expect(resource.enabled).to eq(true)
      end
    end

    context 'a valid override' do
      let(:enabled) { false }

      it 'returns the override' do
        expect(resource.enabled).to eq(false)
      end
    end

    context 'an invalid override' do
      let(:enabled) { :thing }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#config' do
    let(:config) { nil }
    let(:resource) do
      r = super()
      r.config(config) unless config.nil?
      r
    end

    context 'no override' do
      let(:config) { nil }

      it 'defaults to nil' do
        expect(resource.config).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:config) { { message_format: 'test' } }

      it 'returns the override' do
        expect(resource.config).to eq(config)
      end
    end

    context 'an invalid override' do
      let(:config) { :thing }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
