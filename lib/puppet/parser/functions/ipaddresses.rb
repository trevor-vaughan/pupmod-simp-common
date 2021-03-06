module Puppet::Parser::Functions

  newfunction(
    :ipaddresses,
    :type => :rvalue,
    :doc => <<-EOS
      Return an array of all IP addresses known to be associated with the
      client. If an argument is passed, and is not false, then only return
      non-local addresses.
    EOS
  ) do |args|

    only_remote = args[0]

    retval = []
    lookupvar('::interfaces').split(',').each do |iface|
      iface_addr = lookupvar("::ipaddress_#{iface}")

      retval << iface_addr unless (iface_addr.nil? or iface_addr.strip.empty?)
    end

    retval.delete_if{|x| x =~ /^127/} if only_remote

    retval
  end
end
