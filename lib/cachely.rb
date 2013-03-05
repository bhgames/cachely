require_relative "cachely/version"
require_relative 'cachely/mechanics'
require 'redis'
require 'hiredis'
require 'em-synchrony'
require 'json'
module Cachely
  module ClassMethods
    
    # Called after class methods loaded, this aliases out the old method, puts in place the listener version
    # That only calls it if the cache can't fill in.
    #
    # @name [Symbol] fcn name
    # @return nil
    def singleton_method_added(name)
      if(@cachely_fcns and @cachely_fcns.include?(name) and !self.respond_to?("#{name.to_s.gsub("?",'')}_old".to_sym))
        unless(@cachely_opts[name][:type] and @cachely_opts[name][:type] == "instance")
          self.instance_eval("alias :#{"#{name.to_s.gsub("?",'')}_old".to_sym} :#{name}")
          Cachely::Mechanics.setup_method(self,name, @cachely_opts[name][:time_to_expiry], true)
        end
      end
      super
    end
    
    # Called after methods loaded, this aliases out the old method, puts in place the listener version
    # That only calls it if the cache can't fill in.
    #
    # @name [Symbol] fcn name
    # @return nil
    def method_added(name)
      if(@cachely_fcns and @cachely_fcns.include?(name) and !self.new.respond_to?("#{name.to_s.gsub("?",'')}_old".to_sym))
        # only do this if we either haven't explicitly labeled fcn type, or it's not class.
        unless(@cachely_opts[name][:type] and @cachely_opts[name][:type] == "class")
          self.class_eval("alias :#{"#{name.to_s.gsub("?",'')}_old".to_sym} :#{name}") #alias old function out
          Cachely::Mechanics.setup_method(self,name, @cachely_opts[name][:time_to_expiry])
        end
      end
      super
    end

    # Catches the method name, stores for after because methods aren't loaded when this is called.
    #
    # @fcn [Symbol] fcn name
    # @opts [Hash] options
    # @extension No idea
    # @return [Array] Array of current fcns to be added.
    def cachely(fcn, opts = {}, &extension)
      @cachely_fcns ||= []
      @cachely_opts ||= {}
      
      @cachely_fcns << fcn
      @cachely_opts[fcn] = opts
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
