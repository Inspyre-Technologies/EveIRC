module Cinch
  module Helpers
    
    ###
    # @author Taylor-Jayde J. Blackstone <t.blackstone@inspyre.tech>
    # @since 6.5.9
    #
    # @description This library is a namespace for stripping output of the bot of different errant items that could
    #   show. For example; the TagStrip module includes the stripper function for stripping <html_tags>
    module StringClean
      
      ###
      # @author David H. <devyo@sinsira.net>
      # @since 6.5.9
      #
      # @description This library contains the 'stripper' function which strips html tags from any string
      # @example Strips a string of tags
      #   string = "A <xref>ball game</xref> played by individuals competing against one another in which the object is to hit a ball into each of a series of (usually 18 or nine) holes in the minimum number of <xref>strokes</xref>"
      #   StringClean::TagStrip.stripper(string) #=> 'A ball game played by individuals competing against one another in which the object is to hit a ball into each of a series of (usually 18 or nine) holes in the minimum number of strokes'
      module TagStrip
        
        # @param [Array] definition_array The array containing the definitions you want to be cleaned of \<tags\>
        
        def self.stripper(definition_array)
        
        end
      
      
      end
    end
  end
end