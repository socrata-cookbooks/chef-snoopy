# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::remove::config' do
  describe file('/etc/snoopy.ini') do
    it 'does not exist' do
      expect(subject).to_not be_file
    end
  end
end
