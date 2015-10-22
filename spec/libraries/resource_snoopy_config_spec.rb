# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_snoopy_config'

describe Chef::Resource::SnoopyConfig do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:snoopy_config)
    end

    it 'sets the correct supported actions' do
      expect(resource.allowed_actions).to eq([:nothing, :create, :remove])
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:create])
    end
  end

  describe '#config' do
    let(:source) { nil }
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
      let(:config) { { key: 'value' } }

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
