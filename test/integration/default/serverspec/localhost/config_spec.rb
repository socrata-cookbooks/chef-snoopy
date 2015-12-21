# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::default::config' do
  describe file('/etc/snoopy.ini') do
    it 'containts a Snoopy config' do
      expect(subject.content).to match(/^\[snoopy\]$/)
    end
  end
end
