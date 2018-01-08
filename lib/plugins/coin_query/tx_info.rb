def txInfo(m, coin, txHash)

  coin = coin.downcase

  # This case statement detects what
  # the user inputs and allows us to
  # properly handle the request.

  case coin

  when "btc", "bitcoin", "doge", "dogecoin", "dash", "ltc", "litecoin", "eth", "ethereum"

    # If a user types the entirety of
    # the coin name, we can shorten it
    # to it's symbol.

    if coin == "bitcoin"
      coin = "btc"
    end

    if coin == "dogecoin"
      coin = "doge"
    end

    if coin == "litecoin"
      coin = "ltc"
    end

    if coin == "ethereum"
      coin = "eth"
    end

    # Now we take the information provided
    # and make a query to the BlockCypher
    # API

    begin
      data = JSON.parse(open("https://api.blockcypher.com/v1/#{coin}/main/txs/#{txHash}").read)
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        m.reply("I'm sorry, there's either a problem with the API or your request.")
        m.reply("Please check your hash or currency spelling, or please try again later.")
        return "error"
      end
    else

      # After a little error handling above
      # we gather all the information we need.

      toAddress     = data['outputs']
      fromAddress   = data['inputs']
      total         = data['total']

      # Including the confirmations, and then
      # we commify those

      confirmations = data['confirmations']
      confirmations = commify(confirmations)

      fee           = data['fees']
      timeReceived  = data['received']

      # Ethereum is the only coin on this API
      # that requires a different method to
      # make the amounts more readable. Therefore
      # we will change it up if 'eth' is slected.

      if coin == "eth"
        fee = fee.to_f / 1000000000000000000
        total  = total.to_f / 1000000000000000000
      else
        fee = fee.to_f / 100000000
        total  = total.to_f / 100000000
      end

      # Then finally that fee gets commified

      fee    = commify(fee)

      # Just to add a bit more readability we
      # have the code determine if there are
      # six or more confirmations. Red if there
      # are not, green if there are.

      if confirmations.to_i >= 6
        confirmations = Format(:green,:bold, "#{confirmations}")
      else
        confirmations = Format(:red,:bold, "#{confirmations}")
      end

      # The 'confirmed' key does not exist on the
      # API if the tx has gotten no confirmations
      # we have to handle that or the code breaks.

      if data.key?('confirmed')
        timeConfirmed = data['confirmed']
        timeConfirmed = Time.parse(timeConfirmed)
      else
        timeConfirmed = nil
      end

      # Same with preference, we have to handle it
      # or it might break.

      if data.key?('preference')
        preference = data['preference']
      else
        preference = nil
      end

      # And again with the 'confirmed' key.

      if timeConfirmed == nil
        confirmedAnswer = Format(:red,:bold, "Unconfirmed")
      else
        confirmedAnswer = Format(:green,:bold, "#{timeConfirmed}")
      end

      timeReceived = Time.parse(timeReceived)

      # Now that we have the information we
      # need, it's safe to truncate the hash
      # so we don't have to spit the whole thing
      # back out into IRC.

      txHash = txHash[0..15]

      # We set up the arrays to dump the info
      # info...

      finalAddress = []
      finalFrom    = []

      for i in toAddress
        i = i['addresses']
        i = i.to_s
        i = i[2..9]
        i << "..."

        finalAddress.push("#{i}")
      end

      finalAddress = finalAddress.join(", ")

      for i in fromAddress
        i = i['addresses']
        i = i.to_s
        i = i[2..9]
        i << "..."

        finalFrom.push("#{i}")
      end

      finalFrom = finalFrom.join(", ")

      # Then finally we give the info
      # to the IRC user
      
      return("Tx Hash: #{txHash}... | Coin: #{coin.upcase} | To: #{finalAddress} | From: #{finalFrom} | Received: #{timeReceived} | Value: #{total} | Fee: #{fee} | Confirmations: #{confirmations} | Confirmed: #{confirmedAnswer}")

    end
  end
end
