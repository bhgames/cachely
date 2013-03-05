#place all mechanics methods here bc we do not want to introduce random method namespaces to objects
module Cachely
  module Mechanics
    
    # Connects to the Redis store you want to use for a cache.
    #
    # @opt [Hash<Symbol>] 
    # @return [Boolean] success or not
    def self.connect(opts = {})
      @redis ||= Redis.new(
        :host => opts[:host], 
        :port => opts[:port],
        :password => opts[:password],
        :driver => opts[:driver])
    end
    
    # Flush the Redis store of all keys.
    #
    # @return [String] success or not, normally "OK"
    def self.flush_all_keys
      redis.flushdb
    end

    # Grab current redis instance. Has ability to reconnect for you if it fails.
    #
    # @return [Redis], instance of Redis client.
    def self.redis
      @tries = 0 unless @tries
      begin
        @redis.get("test") #tests to see if we're still authed.
        @tries = 0 #means we can reset our trymeter.
      rescue Exception => e
        @tries+=1 if @tries
        if @tries<5
          connect
        end
      end
      return @redis  
    end
   
    # Defines the method using my hacky eval script. So far, this is the only way I've found that
    # allows me to define variable argument length definitions. If you have a better idea, please
    # refactor it!
    #
    # @name [Symbol] fcn name
    # @return nil
    def self.setup_method(klazz, name, time_to_expire_in_s, is_class_method = false) 
      context = (is_class_method ? klazz : klazz.new)
      args_str = context.method("#{name.to_s}_old".to_sym).parameters.map { |k| k.last}.join(',')
      args_to_use_in_def = args_str.empty? ? "" : "," + args_str
      time_exp_str = time_to_expire_in_s.nil? ? ",nil" : ",time_to_expire_in_s"

      to_def_header=nil

      if is_class_method
        to_def_header = "klazz.define_singleton_method(:#{name}) do"
      else
        to_def_header = "klazz.send(:define_method, :#{name}) do"
      end

      to_def = ("#{to_def_header} #{args_str.empty? ? "" : "|#{args_str}|"}; " +
        "result = Cachely::Mechanics.get(self,:#{name}#{time_exp_str}#{args_to_use_in_def});" +
        "return result.first if result.is_a?(Array);" + 
        "result = self.send(:#{"#{name.to_s}_old"}#{args_to_use_in_def});" + 
        "Cachely::Mechanics.store(self,:#{"#{name.to_s}"}, result#{time_exp_str}#{args_to_use_in_def});" +
        "return result;" + 
        "end"
      )
      eval(to_def)
    end
 
    # Force-expires a result to a method with this signature given by obj, method, args.
    #
    # @obj [Object] the object you're calling method on
    # @method [String,Symbol] the method name
    # @args The arguments of the method
    # @return The original response of the method back, whatever it may be, or nil.
    def self.expire(obj, method, *args)
      key = redis_key(obj, method, *args)
      result = get(obj,method,1,*args)
      redis.del(key)
      result.nil? ? nil : result.first
    end   

    # Gets a cached response to a method.
    #
    # @obj [Object] the object you're calling method on
    # @time_to_exp_in_s [Fixnum] num of seconds to set expire on key. Needs to be reset.
    # @method [String,Symbol] the method name
    # @args The arguments of the method
    # @return The original response of the method back, whatever it may be.
    def self.get(obj, method, time_to_exp_in_s, *args)
      key = redis_key(obj, method, *args)
      result = redis.get(key)
      p "searchign for #{key}"
      if result
        p "retyurning #{key}"
        redis.expire(key, time_to_exp_in_s) if time_to_exp_in_s #reset the expiry
        #return an array, bc if the result stored was nil, it looks the same as if
        #we got no result back(which we would return nil) so we differentiate by putting
        #our return value always in an array. Easy to check.
        return [map_s_to_param(result)]
      end   
    end
    
    # Stores the result in it's proper cached location on redis by getting the redis key and parsing
    # The result into a storable string, mostly made up of recursive json.
    #
    # @obj [Object] object you call method on
    # @method [Symbol] Method name
    # @result Anything, really.
    # @time_to_exp_in_s time in seconds before it expires
    # @args Arguments of the method
    # @return [String] Should be "Ok" or something similar.
    def self.store(obj, method, result, time_to_exp_in_sec, *args) 
      p "storing #{redis_key(obj, method, *args)}"
      redis.set(redis_key(obj, method, *args), map_param_to_s(result))
      redis.expire(redis_key(obj, method, *args), time_to_exp_in_sec) if time_to_exp_in_sec
    end
    
    # Converts method name and arguments into a coherent key. Creates a hash and to_jsons it
    # And that becomes the redis key. Spiffy, I know.
    #
    # @method [Object, Symbol, Args] The context, method name symbol, and args.
    # @return [String] The proper redis key to be used in storage.
    def self.redis_key(context, method, *args)
      map_param_to_s({
        :context => context,
        :method => method,
        :args => args
      })
    end
    
    # Turns any string into a parameter. Current supported types are primitives, orm models
    # That respond to id and have an updated_at field, and objects that have a to_json method.
    #
    # @s The string to convert
    # @return [Object] The respawned object
    def self.map_s_to_param(s)
      begin
        respawned_hash = JSON.parse(s)
        
        if respawned_hash.is_a?(Array)
          respawned_hash.map! do |piece|
            map_s_to_param(piece)
          end
        elsif respawned_hash.is_a?(Hash)
          respawned_hash = respawned_hash.inject(Hash.new) do |new_hash, entry|
            new_hash[map_s_to_param(entry[0])] = map_s_to_param(entry[1])
            new_hash
          end
        end
        
        return respawned_hash
      rescue JSON::ParserError => e
        #The only times the string isn't json is if it is a primitive, or an ORM object
        #This exception happens then, we catch it, and check orm signature.
        
        return map_s_to_obj(s)
      end
      
    end
    
    # Turns String into an actual object
    #
    # @s The string to convert
    # @return The respawned object
    def self.map_s_to_obj(s)
      class_or_instance = s.split("|").first
      type = s.split("|")[1]
      data = s.gsub(/^#{class_or_instance}\|#{type}\|/,'')

      case type
      when "TrueClass"
        return true
      when "FalseClass"
        return false
      when "Symbol"
        return data.to_sym
      when "Fixnum"
        return data.to_i
      when "Float"
        return data.to_f
      when "String"
        return data
      when "NilClass"
        return nil
      when "Time"
        return DateTime.parse(data).to_time
      when "DateTime"
        return DateTime.parse(data)
      when "Date"
        return DateTime.parse(data).to_date
      else
        class_or_instance == "instance" ? obj = Object.const_get(type).new : obj = Object.const_get(type)
        JSON.parse(data).each do |key, value|
          obj.send(key+"=",value) if obj.respond_to?(key+"=")
        end

        return obj
      end
    end 

    # Turns any parameter into a string. Current supported types are primitives, orm models
    # That respond to id and have an updated_at field, and objects that have a to_json method.
    #
    # @p The object to convert
    # @return [String] The redis coded string.
    def self.map_param_to_s(p)

      if(p.is_a?(Hash)) 
        return map_hash_to_s(p)
      elsif(p.is_a?(Array))
        return map_array_to_s(p)
      elsif(p.respond_to?("to_json"))
        translated = nil

        if p.is_a?(String)
          translated = "instance|"+p.class.to_s+"|"+p
        elsif p.is_a?(Symbol)
          translated = "instance|"+p.class.to_s+"|"+p.to_s
        elsif p.nil?
          translated = "instance|NilClass|nil"
        elsif p.is_a?(TrueClass)
          translated = "instance|TrueClass|true"
        elsif p.is_a?(FalseClass)
          translated = "instance|FalseClass|false"
        elsif p.is_a?(Fixnum)
          translated = "instance|Fixnum|" + p.to_s
        elsif p.is_a?(Float)
          translated = "instance|Float|" + p.to_s
        elsif p.is_a?(Time)
          translated = "instance|Time|" + p.to_s
        elsif p.is_a?(DateTime)
          translated = "instance|DateTime|" + p.to_s
        elsif p.is_a?(Date)
          translated = "instance|Date|" + p.to_s
        elsif p.is_a?(ActiveRecord::Base) and JSON.parse(p.to_json)[p.class.to_s.underscore]
          #don't want { "dummy_model" = > {:attributes => 1}}
          #want {:attributes => 1}
          #this is default AR to_json
          #we use normal else below if own to_json method defined.
          translated = "instance|#{p.class.to_s}|#{JSON.parse(p.to_json)[p.class.to_s.underscore].to_json}"
        else
          my_json = nil
          begin
            my_json = p.to_json #active record classes have circ references, we catch them below.
          rescue ActiveSupport::JSON::Encoding::CircularReferenceError => e
            my_json = "{}"
          end
          translated = (p.to_s.match(/^#</) ? "instance|#{p.class}" : "class|#{p.to_s}") + "|"+ my_json
        end

        return translated
      end
    end
    
    # Maps hash to s, basically does recursive call to map_param_to_s to get everythign inside
    # and then to_jsons.
    #
    # @p [Hash] Incoming hash
    # @return [String] Outgoing redis string
    def self.map_hash_to_s(p)
      p.inject(Hash.new) do |hash, entry|
        hash[map_param_to_s(entry[0])] = map_param_to_s(entry[1])
        hash
      end.to_json
    end
    
    # Map array to s, calls recursively on elements then to json
    #
    # @p [Array] Incoming array
    # @return [String] Outgoing redis string
    def self.map_array_to_s(p)  
      p.map do |part|
        map_param_to_s(part)
      end.to_json
    end
    

  end
end
