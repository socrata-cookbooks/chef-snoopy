# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::default::app' do
  describe package('snoopy') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
