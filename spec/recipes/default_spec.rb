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
      expect(chef_run).to install_snoopy('default').with(source: nil)
    end
  end

  context 'a custom app source attribute' do
    let(:overrides) { { snoopy: { app: { source: '/tmp/snoopy' } } } }

    it 'installs Snoopy with the custom source' do
      expect(chef_run).to install_snoopy('default').with(source: '/tmp/snoopy')
    end
  end
end
