#place all mechanics methods here bc we do not want to introduce random method namespaces to objects
module Cachely
  module Mechanics
    
    # Connects to the Redis store you want to use for a cache.
    #
    # @opt [Hash<Symbol>] 
    # @return [Boolean] success or not
    def self.connect(opts = {})
      @redis ||= Redis.new( :driver => :hiredis,
        :host => opts[:host], 
        :port => opts[:port],
        :password => opts[:password],
        :driver => opts[:driver])
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
    
    # Gets a cached response to a method.
    #
    # @method [String,Symbol] the method name
    # @args The arguments of the method
    # @return The original response back.
    def self.get(method, *args)
      redis.get(redis_key(method, *args))
    end
    
    # Converts method name and arguments into a coherent key. Creates a hash and to_jsons it
    # And that becomes the redis key. Spiffy, I know.
    #
    # @method [String,Symbol] The method name
    # @return [String] The proper redis key to be used in storage.
    def self.redis_key(method, *args)
      {
        :method => method.to_s,
        :args => args.map { |param| map_param_to_s(param) }.join("|")
      }.to_json
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
        
        return map_s_to_orm(s) if orm_signature(s)
        return map_s_to_primitive(s)
      end
      
    end
    
    # Determines if hash from json storage represents an ORM object, basically checks
    # for ID key, updated at key, class name. If you make a hash like this, then you'll likely
    # Trigger this ORM thing, screwing up caching.
    #
    # @s The string to convert
    # @return [Boolean] True if the hash is likely an ORM representation
    def self.orm_signature(s)
      s.split(":").first=="ORM"
    end
    
    # Turns String into a ORM object
    #
    # @s The string to convert
    # @return [ActiveRecord::Base] The respawned object
    def self.map_s_to_orm(s)
      hash = JSON.parse(s.split(":").last) #Cut off the ORM tag, so we have real JSON.
      
      Object.const_get(hash[:class]).find(:id) #load up class, get by id.
    end 
    
    # Turns String into a primitive object
    #
    # @s The string to convert
    # @return The respawned object
    def self.map_s_to_primitive(s)
      type = s.split(":").first
      data = s.gsub(/^#{type}:/,'')
      
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
      else
        obj = Object.const_get(type)
        data.each do |key, value|
          obj.send(key+"=",value)
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
      elsif(p.respond_to?("id") and p.respond_to?("updated_at"))
        return map_orm_object_to_s(p)
      elsif(p.respond_to?("to_json"))
        #below do extra search if string bc string puts annoying quotes in json like "\"1\""
        #breaks the parser on the return translation.
        translated = nil
        if p.is_a?(String)
          translated = p
        elsif p.is_a?(Symbol)
          translated = p.to_s
        elsif p.nil?
          translated = "nil"
        else
          translated = p.to_json
        end
          
        return p.class.to_s + ":" + translated
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
        map_param_to_s(p)
      end.to_json
    end
    
    # Orm objects have ids and updated_at fields, mostly. So we use those to mark
    # our key with times. If a key has a 8pm updated at time embedded in it, when
    # the orm object changes, and it gets passed in again, it's key will not have 8pm in it.
    # So that cache entry will just expire as normal.
    #
    # @p [ActiveRecord::Base] ActiveRecord object
    # @return [String]
    def self.map_orm_object_to_s(p)
      "ORM:" + { #ORM tag makes sure this isnt reconstituted as a hash. Invalid JSON, I know.
        :class => p.class.to_s, #Need to retain case sensitivity.
        :id => p.id,
        :updated_at => p.updated_at
      }.to_json
    end
    
    # Stores the result in it's proper cached location on redis by getting the redis key and parsing
    # The result into a storable string, mostly made up of recursive json.
    #
    # @method [Symbol] Method name
    # @result Anything, really.
    # @args Arguments of the method
    # @return [String] Should be "Ok" or something similar.
    def self.store(method, result, *args) 
      redis.set(redis_key(method, *args), map_param_to_s(result))
    end
    
  end
end