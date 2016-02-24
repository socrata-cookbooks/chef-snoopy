# Encoding: UTF-8

require_relative '../spec_helper'

describe 'snoopy::disabled::app' do
  describe package('snoopy') do
    it 'is installed' do
      expect(subject).to be_installed
    end

    it 'is a recent version' do
      expect(subject.version.version.to_i).to be > 1
    end
  end
end
