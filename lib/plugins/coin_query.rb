require 'cinch'
require_relative 'coin_query/coin_info'
require_relative 'coin_query/tx_info'
require_relative 'coin_query/addr_info'
require_relative 'coin_query/coin_converter'
require_relative 'helpers/commify'

module Cinch
  module Plugins
    class CoinQuery
      include Cinch::Plugin
      
      set :plugin_name, 'coinquery'
      
      match /coin-info (.+)/i, method: :coin
      match /coin (.+)/i, method: :coin
        
      def coin(m, query)
        
        results = basicInfo(m, query)
        
        if results == "error"
          return
        end
        
        m.reply("#{results}")
        
      end
      
      match /coin-transaction (.+?) (.+)/i, method: :transaction
      match /coin-tx (.+?) (.+)/i, method: :transaction
      
      def transaction(m, coin, txHash)
        
        coin = coin.downcase
        
        results = txInfo(m, coin, txHash)
        
        if results == "error"
          return
        end
        
        m.reply("#{results}")
        
      end
      
      match /coin-address (.+?) (.+)/i, method: :address
      match /coin-addr (.+?) (.+)/i, method: :address
      
      def address(m, coin, addr, verbose="no")
        
        if ["-v", "--verbose"].include?(coin)
          return
        end
        
        coin = coin.downcase
        
        results = addressInfo(m, coin, addr, verbose)
        
        if results == "error"
          return
        end
        
        m.reply("#{results}")
        
      end
      
      match /coin-address (-v|--verbose) (.+?) (.+)/i, method: :verboseAddr
      match /coin-addr (-v|--verbose) (.+?) (.+)/i, method: :verboseAddr
      
      def verboseAddr(m, verbose, coin, addr)
        
        verbose = "yes"
        
        address(m, coin, addr, verbose)
        
      end
      
      match /coin-convert (.+?) (.+?) (.+)/i, method: :convert
      
      def convert(m, qAmount, qSym, target)
        
        qSym    = qSym.upcase
        target  = target.upcase
        
        result  = converter(m, qAmount, qSym, target)
        
        qAmount = commify(qAmount)
        
        if result[0] == "error"
          eMsg = result[1]
          return m.reply("#{eMsg}")
        end
        
        m.reply("The price of #{qAmount}#{qSym} is #{result}#{target}.")
        
      end
      
    end
  end
end
