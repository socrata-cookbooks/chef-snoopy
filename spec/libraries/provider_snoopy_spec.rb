# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_snoopy'

describe Chef::Provider::Snoopy do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::Snoopy.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

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

  describe '#action_install' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    before(:each) do
      [:package, :file, :ld_so_preload].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    shared_examples_for 'any attribute set' do
      it 'adds Snoopy to the LD preloads' do
        p = provider
        expect(p).to receive(:file).with('/etc/ld.so.preload').and_yield
        expect(p).to receive(:content)
        expect(p).to receive(:lazy).and_yield
        expect(p).to receive(:ld_so_preload).with(:add)
        p.action_install
      end
    end

    context 'no custom source (default)' do
      let(:source) { nil }

      it_behaves_like 'any attribute set'

      it 'installs the default Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('snoopy')
        p.action_install
      end
    end

    context 'a custom source' do
      let(:source) { '/tmp/snoopy' }

      it_behaves_like 'any attribute set'

      it 'installs the custom Snoopy package' do
        p = provider
        expect(p).to receive(:package).with('/tmp/snoopy')
        p.action_install
      end
    end
  end

  describe '#action_remove' do
    before(:each) do
      [:file, :ld_so_preload, :package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'removes Snoopy from the LD preloads' do
      p = provider
      expect(p).to receive(:file).with('/etc/ld.so.preload').and_yield
      expect(p).to receive(:content)
      expect(p).to receive(:lazy).and_yield
      expect(p).to receive(:ld_so_preload).with(:remove)
      p.action_remove
    end

    it 'removes the Snoopy package' do
      p = provider
      expect(p).to receive(:package).with('snoopy').and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end
  end

  describe '#ld_so_preload' do
    let(:action) { nil }
    let(:file_content) { nil }
    let(:res) { provider.ld_so_preload(action) }

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
          expect(res).to eq('/lib/snoopy.so')
        end
      end

      context 'an empty file' do
        let(:file_content) { '' }

        it 'returns the correct result string' do
          expect(res).to eq('/lib/snoopy.so')
        end
      end

      context 'a file with a single entry' do
        let(:file_content) { '/lib/test1.so' }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/snoopy.so")
        end
      end

      context 'a file with multiple entries' do
        let(:file_content) { "/lib/test1.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/test2.so\n/lib/snoopy.so")
        end
      end

      context 'a file that already includes snoopy' do
        let(:file_content) { "/lib/test1.so\n/lib/snoopy.so\n/lib/test2.so" }

        it 'returns the correct result string' do
          expect(res).to eq("/lib/test1.so\n/lib/snoopy.so\n/lib/test2.so")
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
        let(:file_content) { "/lib/test1.so\n/lib/snoopy.so\n/lib/test2.so" }

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
