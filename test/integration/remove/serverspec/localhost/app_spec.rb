# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::remove::app' do
  describe package('snoopy') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
