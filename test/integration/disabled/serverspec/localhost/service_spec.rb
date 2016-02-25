# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::disabled::service' do
  describe file('/etc/ld.so.preload') do
    it 'does not load the snoopy lib' do
      expect(subject.content).to_not match(%r{^/lib/libsnoopy\.so$})
    end
  end

  log = case os[:family]
        when 'ubuntu', 'debian'
          '/var/log/auth.log'
        when 'redhat'
          '/var/log/secure'
        end
  describe file(log) do
    it 'is not logging system commands' do
      `ls`
      expect(subject.content).to_not match(%r{snoopy.*filename:/bin/ls})
    end
  end
end
