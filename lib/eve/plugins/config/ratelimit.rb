module Cinch
  module Helpers
  
    def ratelimit(id, limit)
      if id.class != Symbol
        raise ArgumentError, "id should be a Symbol"
      end
      if limit.class != Fixnum
        raise ArgumentError, "limit should be Fixnum"
      end

      synchronize(("ratelimit_" + id.to_s).to_sym) do
        now = Time.now.to_i
        shared[:ratelimit] ||= Hash.new
        shared[:ratelimit][id] ||= 0

        difference = now - shared[:ratelimit][id]
        if difference < limit
          return (limit - difference)
        end

        shared[:ratelimit][id] = now
        return 0
      end
    end
  end
end
