# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_snoopy_service'

describe Chef::Resource::SnoopyService do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:snoopy_service)
    end

    it 'sets the correct supported actions' do
      expect(resource.allowed_actions).to eq([:nothing, :enable, :disable])
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:enable])
    end
  end
end
