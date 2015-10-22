# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::default' do
  let(:overrides) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      overrides && overrides.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'default attributes' do
    it 'installs Snoopy with no source' do
      expect(chef_run).to create_snoopy('default').with(source: nil)
    end

    it 'configures Snoopy with no overrides' do
      expect(chef_run).to create_snoopy('default').with(config: {})
    end
  end

  context 'a custom app source attribute' do
    let(:overrides) { { snoopy: { app: { source: '/tmp/snoopy' } } } }

    it 'installs Snoopy with the custom source' do
      expect(chef_run).to create_snoopy('default').with(source: '/tmp/snoopy')
    end
  end

  context 'a custom config attribute' do
    let(:overrides) { { snoopy: { config: { message_format: 'test' } } } }

    it 'configures Snoopy with the custom config' do
      expect(chef_run).to create_snoopy('default')
        .with(config: { 'message_format' => 'test' })
    end
  end
end
