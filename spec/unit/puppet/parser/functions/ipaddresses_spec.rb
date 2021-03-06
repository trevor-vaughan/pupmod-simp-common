#!/usr/bin/env ruby -S rspec
require 'spec_helper'

describe Puppet::Parser::Functions.function(:ipaddresses) do
  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:ipaddresses)
    scope.method(function_name)
  end

  # Mock out the Facts
  context "All Interfaces Have IP Addresses" do
    before :each do
      scope.stubs(:lookupvar).with("::interfaces").returns('eth0,eth1,lo')
      scope.stubs(:lookupvar).with("::ipaddress_eth0").returns('1.2.3.4')
      scope.stubs(:lookupvar).with("::ipaddress_eth1").returns('5.6.7.8')
      scope.stubs(:lookupvar).with("::ipaddress_lo").returns('127.0.0.1')
    end

    it 'should return an array with no empty or nil values' do
      (subject.call([]).delete_if{|x| x and x =~ /\S/}).should =~ []
    end
  end

  context "All Interfaces Do Not Have IP Addresses" do
    before :each do
      scope.stubs(:lookupvar).with("::interfaces").returns('eth0,eth1,lo')
      scope.stubs(:lookupvar).with("::ipaddress_eth0").returns('1.2.3.4')
      scope.stubs(:lookupvar).with("::ipaddress_eth1").returns('')
      scope.stubs(:lookupvar).with("::ipaddress_lo").returns('127.0.0.1')
    end

    it 'should return an array with no empty or nil values' do
      (subject.call([]).delete_if{|x| x and x =~ /\S/}).should =~ []
    end
  end

  context "The system has no interfaces" do
    before :each do
      scope.stubs(:lookupvar).with("::interfaces").returns('')
    end

    it 'should not raise an error' do
      expect {
        subject.call([])
      }.not_to raise_error
    end
  end
end
