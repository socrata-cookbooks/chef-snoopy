# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::app' do
  describe package('snoopy') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe file('/etc/snoopy.ini') do
    it 'containts a Snoopy config' do
      expect(subject.content).to match(/^\[snoopy\]$/)
    end
  end

  describe file('/etc/ld.so.preload') do
    it 'loads the snoopy lib' do
      expect(subject.content).to match(%r{^/lib/libsnoopy\.so$})
    end
  end

  describe file('/var/log/auth.log') do
    it 'is logging system commands' do
      `ls`
      expect(subject.content).to match(%r{snoopy.*filename:/bin/ls})
    end
  end
end
