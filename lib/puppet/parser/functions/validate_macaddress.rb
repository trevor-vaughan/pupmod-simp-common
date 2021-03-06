module Puppet::Parser::Functions

  newfunction(:validate_macaddress, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are valid MAC addresses.

    The following values will pass:
      $macaddress = 'CA:FE:BA:BE:00:11'
      validate_macaddress($macaddress)
      validate_macaddress($macaddress, '00:11:22:33:44:55')
      validate_macaddress([$macaddress, '00:11:22:33:44:55'])

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_macaddress(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      arg = Array(arg)
      arg.each do |macaddr|
        unless macaddr =~ /^\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}$/ then
          raise Puppet::ParseError, ("'#{macaddr}' is not a MAC address.")
        end
      end
    end
  end
end
