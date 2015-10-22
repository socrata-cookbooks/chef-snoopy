# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_snoopy_service'
require_relative '../../libraries/resource_snoopy_service'

describe Chef::Provider::SnoopyService do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SnoopyService.new(name, run_context) }
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

  describe '#action_enable' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:file)
    end

    it 'adds Snoopy to the LD preloads' do
      p = provider
      expect(p).to receive(:file).with('/etc/ld.so.preload').and_yield
      expect(p).to receive(:content)
      expect(p).to receive(:lazy).and_yield
      expect(p).to receive(:ld_so_preload).with(:add)
      p.action_enable
    end
  end

  describe '#action_disable' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:file)
    end

    it 'removes Snoopy from the LD preloads' do
      p = provider
      allow(p).to receive(:file).and_call_original
      expect(p).to receive(:file).with('/etc/ld.so.preload').and_yield
      expect(p).to receive(:content)
      expect(p).to receive(:lazy).and_yield
      expect(p).to receive(:ld_so_preload).with(:remove)
      p.action_disable
    end
  end

  describe '#ld_so_preload' do
    let(:action) { nil }
    let(:file_content) { nil }
    let(:res) { provider.ld_so_preload(action) }

    before(:each) do
      allow(File).to receive(:exist?)
    end

    before(:each) do
      f = '/etc/ld.so.preload'
      allow(File).to receive(:exist?).with(f).and_return(!file_content.nil?)
      allow(File).to receive(:open).with(f)
        .and_return(double(read: file_content))
    end

    context 'an :add action' do
      let(:action) { :add }

      context 'a non-existent file' do
        let(:file_content) { nil }

        it 'returns the correct result string' do
          expect(res).to eq('/lib/libsnoopy.so')
        end
      end

      context 'an empty file' do
        let(:file_content) { '' }

        it 'returns the correct result string' do
          expect(res).to eq('/lib/libsnoopy.so')
        end
      end

      context 'a file with a single entry' do
        let(:file_content) { '/lib/test1.so' }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/libsnoopy.so")
        end
      end

      context 'a file with multiple entries' do
        let(:file_content) { "/lib/test1.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/test2.so\n/lib/libsnoopy.so")
        end
      end

      context 'a file that already includes snoopy' do
        let(:file_content) { "/lib/test1.so\n/lib/libsnoopy.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/libsnoopy.so\n/lib/test2.so")
        end
      end
    end

    context 'a :remove action' do
      let(:action) { :remove }

      context 'a non-existent file' do
        let(:file_content) { nil }

        it 'returns the correct result string' do
          expect(res).to eq('')
        end
      end

      context 'an empty file' do
        let(:file_content) { '' }

        it 'returns the correct result string' do
          expect(res).to eq('')
        end
      end

      context 'a file with a single entry' do
        let(:file_content) { '/lib/test1.so' }

        it 'returns the correct result string' do
          expect(res).to eq('/lib/test1.so')
        end
      end

      context 'a file with multiple entries' do
        let(:file_content) { "/lib/test1.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/test2.so")
        end
      end

      context 'a file that already includes snoopy' do
        let(:file_content) { "/lib/test1.so\n/lib/libsnoopy.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/test2.so")
        end
      end
    end

    context 'an invalid action' do
      let(:action) { :test }

      it 'raises an error' do
        expect { res }.to raise_error(Chef::Exceptions::UnsupportedAction)
      end
    end
  end
end
