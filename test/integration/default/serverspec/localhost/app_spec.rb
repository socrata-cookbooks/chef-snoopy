# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::app' do
  describe package('snoopy') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe file('/etc/ld.so.preload') do
    it 'loads the snoopy lib' do
      expect(subject.content).to match(%r{^/lib/snoopy\.so$})
    end
  end
end
