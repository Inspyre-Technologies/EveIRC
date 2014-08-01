require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class CoinQuery
      include Cinch::Plugin

      set :plugin_name, 'coinquery'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      You can use the bot to check market and value data on nearly every cryptocoin!
      Usage:
      * !coin <altcoin> <conventional currency>: This will query the API and return the value of <altcoin> in <conventional currency>.
      * !coin market <altcoin> <altcoin/conventional currency>: This will query the API and return the current market data of <altcoin> in <altcoin/conventional currency>.
      * !coin pairs: This will notice you a list of all the valid pairs of currency you can use to query the bot. This does not include all conventional currency.
      USAGE

      TickerURL = 'https://www.cryptonator.com/api/full/'

      ConversionURL = 'http://rate-exchange.appspot.com/currency?from=USD&to='

      MarketURL = 'http://data.bter.com/api/1/ticker/'

      coins = ["btc to cny","ltc to cny","bc to cny","bqc to cny","btb to cny","btq to cny","btsx to cny","cent to cny","cmc to cny","cnc to cny","dgc to cny","doge to cny","drk to cny","dtc to cny","dvc to cny","exc to cny","ftc to cny","frc to cny","ifc to cny","max to cny","mec to cny","mint to cny","mmc to cny","net to cny","nmc to cny","nxt to cny","ppc to cny","pts to cny","qrk to cny","red to cny","src to cny","tag to cny","tips to cny","tix to cny","vrc to cny","vtc to cny","wdc to cny","xcp to cny","xpm to cny","yac to cny","zcc to cny","zet to cny","btc to usd","ltc to usd","doge to usd","drk to usd","nxt to usd","xcp to usd","ltc to btc","ac to btc","aur to btc","bc to btc","bqc to btc","btb to btc","btsx to btc","buk to btc","c2 to btc","cdc to btc","comm to btc","cmc to btc","cnc to btc","crsale to btc","dgc to btc","doge to btc","drk to btc","dtc to btc","exc to btc","flt to btc","frc to btc","frsh to btc","ftc to btc","gml to btc","kdc to btc","lts to btc","max to btc","mec to btc","mint to btc","mmc to btc","nav to btc","nec to btc","nmc to btc","nas to btc","nfd to btc","nxt to btc","ntx to btc","ppc to btc","prt to btc","pts to btc","qrk to btc","rox to btc","sfr to btc","slm to btc","src to btc","tag to btc","yac to btc","via to btc","vrc to btc","vtc to btc","wdc to btc","xc to btc","xcp to btc","xpm to btc","xmr to btc","qora to btc","zcc to btc","zet to btc","cent to ltc","dvc to ltc","ifc to ltc","net to ltc","red to ltc","tips to ltc","tix to ltc"]

      def error(data, nick, pair)
	eMSG = data['message']
	if eMSG
	  m.reply "#{nick}, #{eMSG} '#{pair}'"
	end
      else
	m.reply "I'm sorry, there's been an unspecified error, #{nick}."
      end

      match /coin (.+?) (.+)/i, method: :value

      def value(m, cur1, cur2)
	return if check_ignore(m.user)

	return if cur1 == "market"

	data = JSON.parse(open("#{TickerURL}#{cur1}-#{cur2}").read)
	info = data['ticker']
	success = data['success']

	return error(data, nick, pair) if success == false

	if success == true
	  price   = info['price']
	  target  = info['target']
	  base    = info['base']

	  price   = sprintf("%.2f", price)
	  price   = price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	  m.reply "#{m.user.nick}, the current #{base} price in #{target} is #{price}."
	  return
	end
	m.reply "Error: #{$!}"
      end

      def conversion(original, currency, value)
	return if check_ignore(m.user)

	data = JSON.parse(open("#{ConversionURL}#{currency}&q=#{value}").read)

	return false if data['err']

	cValue = data['v']
	cValue = sprintf("%.2f", cValue)
	cValue = cValue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	return cValue
      end

      match /coin pairs/i, method: :list_pairs

      def list_pairs(m)
	return if check_ignore(m.user)

	pairs = JSON.parse(open("http://data.bter.com/api/1/pairs").read)
	pairs = pairs.to_s.gsub(/_/, ' ').split(", ")

	m.user.notice "#{pairs.join(", ").to_s}"
	m.user.notice "If you are trying to compare a cryptocoin to a conventional currency try \"!coin market <cryptocurrency> <conventional currency>\""
      end

      match /coin market (.+?) (.+)/i, method: :market

      def market(m, cur1, cur2)
	return if check_ignore(m.user)

	data = JSON.parse(open("#{MarketURL}#{cur1}_usd").read)

	alt   = JSON.parse(open("#{MarketURL}#{cur1}_#{cur2}").read)
	pair  = "#{cur1}_#{cur2}"
	pairs = JSON.parse(open("http://data.bter.com/api/1/pairs").read)

	original  = "USD"

	currency  = cur2

	testVar   = "1.00"

	if pairs.include? pair.downcase
	  last  = alt['last']
	  high  = alt['high']
	  low   = alt['low']
	  avg   = alt['avg']
	  sell  = alt['sell']
	  buy   = alt['buy']

	  m.reply "#{m.user.nick}, #{cur1.upcase} - #{cur2.upcase} | Last Price: #{last} #{cur2.upcase} - High: #{high} #{cur2.upcase} - Low: #{low} #{cur2.upcase} - Average: #{avg} #{cur2.upcase} - Selling Price: #{sell} #{cur2.upcase} - Buying Price: #{buy} #{cur2.upcase}"
	end

	if !pairs.include? pair.downcase
	  if data['result'] == 'true'

	    return m.reply "#{m.user.nick}, I'm sorry, I can't find #{cur2.upcase} in my conversion array! If you're trying to compare cryptocoin pairs you can type !coin pairs to get valid pairs!" if conversion(original, currency, testVar) == false

	    last  = data['last']
	    last  = conversion(original, currency, last)

	    high  = data['high']
	    high  = conversion(original, currency, high)

	    low   = data['low']
	    low   = conversion(original, currency, low)

	    avg   = data['avg']
	    avg   = conversion(original, currency, avg)

	    sell  = data['sell']
	    sell  = conversion(original, currency, sell)

	    buy   = data['buy']
	    buy   = conversion(original, currency, buy)

	    currency = currency.upcase

	    m.reply "#{m.user.nick}, #{cur1.upcase} - #{currency} | Last Price: #{last} #{currency} - High: #{high} #{currency} - Low: #{low} #{currency} - Average: #{avg} #{currency} - Selling Price: #{sell} #{currency} - Buying Price: #{buy} #{currency}"

	    return
	  end
	  m.reply "I'm sorry, there seems to be a problem finding your query!"
	end
      end
    end
  end
end

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like this plugin please consider tipping me on gittip
