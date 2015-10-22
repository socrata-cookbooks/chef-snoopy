# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_snoopy_app'

describe Chef::Resource::SnoopyApp do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:snoopy_app)
    end

    it 'sets the correct supported actions' do
      expect(resource.allowed_actions).to eq([:nothing, :install, :remove])
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:install])
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
end
