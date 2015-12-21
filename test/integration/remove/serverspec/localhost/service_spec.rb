# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::remove::service' do
  describe file('/etc/ld.so.preload') do
    it 'does not load the snoopy lib' do
      expect(subject.content).to_not match(%r{^/lib/libsnoopy\.so$})
    end
  end
end
