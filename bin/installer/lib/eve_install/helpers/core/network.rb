module Network

  class InvalidArgumentError < StandardError

    def msg
      "Somehow an invalid argument was supplied to #{caller}"
    end

    def hint
      'Please fill out a ticket: '
    end

  end

  @ip_addr  = '8.8.8.8'
  @dns_addr = 'google.com'

  def ping(dns = false)
    case dns
    when true
      @command = 'ping -c 1 google.com'
    when false
      @command = 'ping -c 1 8.8.8.8'
    else
      raise InvalidArgumentError
    end
  end

  def do_checks

  end

end
