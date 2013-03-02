require_relative "cachely/version"
require_relative 'cachely/mechanics'
require 'redis'
require 'hiredis'
require 'em-synchrony'
require 'json'
module Cachely
  module ClassMethods
    
    # Called after methods loaded, this aliases out the old method, puts in place the listener version
    # That only calls it if the cache can't fill in.
    #
    # @name [Symbol] fcn name
    # @return nil
    def method_added(name)
      if(@cachely_fcns and @cachely_fcns.include?(name) and !@cachely_fcns_added.include?(name))
        @cachely_fcns_added << name #this method'll get called when we do define method below
        #this halts that.

        self.class_eval("alias #{"#{name.to_s}_old".to_sym} #{name}") #alias old function out

        self.define_method name do |*args| #define new one
          return result if result = Cachely::Mechanics.get(*args) 
          result = send("#{name.to_s}_old".to_sym, *args)
          Cachely::Mechanics.store(result)
        end
      end
    end
    
    # Catches the method name, stores for after because methods aren't loaded when this is called.
    #
    # @fcn [Symbol] fcn name
    # @opts [Hash] options
    # @extension No idea
    # @return [Array] Array of current fcns to be added.
    def cachely(fcn, opts = {}, &extension)
      @cachely_fcns_added ||= []
      @cachely_fcns ||= []
      @cachely_fcns << fcn
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
