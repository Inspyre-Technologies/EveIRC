require 'ostruct'
require 'open-uri'
require 'json'

CoinList  = 'https://min-api.cryptocompare.com/data/all/coinlist'
PriceData = 'https://min-api.cryptocompare.com/data/'

def basicInfo(m, query)

  # First we open the CoinList API and parse it

  data = JSON.parse(open("#{CoinList}").read)

  # If we received an error response, we want
  # to handle that and let the end-user know.

  if data['Response'] == "Error"
    eMsg = data['Message']
    m.reply "I'm sorry, there's been an error: #{eMsg}"
    return "error"
  end
  results = []

  # Now we gather the information on the page
  # to get the information for the query.

  for p in data['Data']

    symbol    = p[0]
    coinName  = p[1]['CoinName']
    url       = p[1]['Url']
    algorithm = p[1]['Algorithm']
    url       = "https://www.cryptocompare.com#{url}"

    if symbol.downcase == query.downcase or coinName.downcase == query.downcase

      # If we're able to find a result, we
      # grab the price as well, and add it.
      begin
        priceSheet = JSON.parse(open("#{PriceData}price?fsym=#{symbol}&tsyms=USD,EUR").read)
      rescue OpenURI::HTTPError => e
        if e.message == "502 Bad Gateway"
          priceSheet = "error"
          priceUsd   = "?"
          priceEur   = "?"
        end
      else

        priceUsd   = priceSheet['USD']
        priceUsd   = commify(priceUsd)
        priceEur   = priceSheet['EUR']
        priceEur   = commify(priceEur)
      end

      results.push("%s (%s) - Algorithm: %s | USD: $%s - EUR: €%s | More Info: %s" % [coinName, symbol, algorithm, priceUsd, priceEur, url])

    end

  end

  # Now we do_check our results, if there are
  # results then we let the end-user see
  # the infomation we've gathered.

  if results.length > 0
    return results
  else

    # If we found nothing, then we should
    # tell the user that.

    m.reply("I am unable to find information for #{query}. Please try again later.")
    return "error"
  end
end
