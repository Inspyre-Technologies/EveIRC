def addressInfo(m, coin, address, verbose="no")

  # Always downcase the coin

  if ["-v", "--verbose"].include?(coin)
    return
  end

  coin = coin.downcase

  # To add a bit of ease for the user
  # we'll go ahead and put some if
  # statements to convert full coin
  # names to their symbol.

  if coin == "ethereum"
    coin = "eth"
  end

  if coin == "litecoin"
    coin = "ltc"
  end

  if coin == "bitcoin"
    coin = "btc"
  end

  if coin == "dogecoin"
    coin = "doge"
  end

  if !["btc", "eth", "dash", "ltc"].include?(coin)
    m.reply "I'm sorry, I currently only support the following coins when querying addresses:"
    m.reply "Bitcoin (BTC), Litecoin (LTC), Ethereum (ETH), and Dash (DASH)"
    return "error"
  end

  # We put a begin here because we
  # want to be able to recover from
  # any OpenURI errors we enounter.

  begin
    data = JSON.parse(open("https://api.blockcypher.com/v1/#{coin}/main/addrs/#{address}?limit=3").read)
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      m.reply("I'm sorry, there's either a problem with the API or your request.")
      m.reply("Please do_check your address or currency spelling, or please try again later.")
      return "error"
    end
    if e.message == '400 Bad Request'
      m.reply("I'm sorry, there's either a problem with the API or your request.")
      m.reply("Please do_check your address or currency spelling, or please try again later.")
      return "error"
    end
  else

    if data.key?('error')
      eMsg = data['error']
      m.reply "#{eMsg}"
      return "error"
    end

    # Gather the address, truncate it,
    # and then append '...' to it.

    address       = data['address']
    address       = address[0..7]
    address       << "..."

    # Gather other information

    totalReceived = data['total_received']
    totalSent     = data['total_sent']
    balance       = data['balance']

    # In order to get a human-readable
    # amount of coin, we will need to do
    # some math according to the coin's
    # lowest increment.

    if coin == "eth"
      totalReceived = totalReceived.to_f / 1000000000000000000
      totalSent     = totalSent.to_f / 1000000000000000000
      balance       = balance.to_f / 1000000000000000000
    else
      totalReceived = totalReceived.to_f / 100000000
      totalSent     = totalSent.to_f / 100000000
      balance       = balance.to_f / 100000000
    end

    # Now let's round and commify

    totalReceived = totalReceived.round(5)
    totalReceived = commify(totalReceived)

    totalSent     = totalSent.round(5)
    totalSent     = commify(totalSent)

    balance       = balance.round(5)
    balance       = commify(balance)

    numberTx      = data['n_tx']
    numberTx      = commify(numberTx)

    unconfirmedTx = data['unconfirmed_n_tx']
    unconfirmedTx = commify(unconfirmedTx)

    finalNumberTx = data['final_n_tx']
    finalNumberTx = commify(finalNumberTx)

    txRefs        = data['txrefs']

    # Create an array to push the
    # information contained in txrefs
    # to.

    formattedRefs  = []
    verboseResults = []

    for i in txRefs

      txHash        = i['tx_hash']
      txHash        = txHash[0..7]
      txHash        << "..."

      confirmations = i['confirmations']
      confirmations = commify(confirmations)

      # To make things a litter easier we
      # go ahead and make the address red
      # or green depending on the confirmation
      # status of each transaction.

      if i.key?('confirmed')
        timeConfirmed = i['confirmed']
        timeConfirmed = Time.parse(timeConfirmed)
      else
        timeConfirmed = Format(:red,:bold, "Unconfirmed")
      end

      if confirmations.to_i >= 6
        txHash = Format(:green,:bold, "#{txHash}")
      else
        txHash = Format(:red,:bold, "#{txHash}")
      end

      value  = i['value']

      if coin == "eth"
        value = value.to_f / 1000000000000000000
      else
        value = value.to_f / 100000000
      end

      # Round and commify

      value = value.round(5)
      value = commify(value)

      # Puuuuuuush!

      formattedRefs.push("#{txHash} (#{value}#{coin.upcase})")

      verboseResults.push(("Tx Hash: %s | Value: %s | Confirmations: %s | Confirmed: %s" % [txHash, value, confirmations, timeConfirmed]))

    end

    # Join!

    formattedRefs = formattedRefs.join(", ")
    verboseReply  = "Address: #{address} | Coin: #{coin.upcase} | Total Sent: #{totalSent} | Total Received: #{totalReceived} | Balance: #{balance} | No. of Tx: #{numberTx} | No. of Unconfirmed Tx: #{unconfirmedTx}"

    # Send to user!

    if verbose == "yes"
      verboseResults.each{|v| m.user.notice v}
      return(verboseReply)
    else
      return("Address: #{address} | Coin: #{coin.upcase} | Total Sent: #{totalSent} | Total Received: #{totalReceived} | Balance: #{balance} | No. of Tx: #{finalNumberTx} | Recent Tx(s): #{formattedRefs}")
      
    end
  end
end
