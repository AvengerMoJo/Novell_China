
module Suse

module Utils

  class UriParam
    attr_accessor :key, :value
    def initialize(key,value)
      @key = key
      @value = value
    end
  end
  
  def self.query_string(params)
    params.map { |x| "#{x.key.to_s}=#{x.value}" }.join('&')
  end
  
  #thanks to gdsx in #ruby-lang
  # ini to hash
  def self.tame(input)
    tamed = {}
  
    # split data on city names, throwing out surrounding brackets
    input = input.split(/\[([^\]]+)\]/)[1..-1]
  
    # sort the data into key/value pairs
    input.inject([]) {|tary, field|
      tary << field
      if(tary.length == 2)
        # we have a key and value; put 'em to use
        tamed[tary[0]] = tary[1].sub(/^\s+/,'').sub(/\s+$/,'')
        # pass along a fresh temp-array
        tary.clear
      end
      tary
    }
  
    tamed.dup.each { |tkey, tval|
      tvlist = tval.split(/[\r\n]+/)
      tamed[tkey] = tvlist.inject({}) { |hash, val|
        k, v = val.split(/=/)
                          hash[k]=v
                          hash
                          }
                  }

        tamed
  end
  
end

end
