require_relative "cachely/version"

module Cachely
  module ClassMethods

    def method_added(name)
      if(@cachely_fcns.include?(name) and !@cachely_fcns_added.include?(name))
        @cachely_fcns_added << name #this method'll get called when we do define method below
        #this halts that.

        self.class_eval("alias #{"#{name.to_s}_old".to_sym} #{name}") #alias old function out

        self.define_method name do |*args| #define new one
          send "#{name.to_s}_old".to_sym, *args
        end
      end
    end

    def cachely(fcn, opts = {}, &extension)
      @cachely_fcns_added ||= []
      @cachely_fcns = []
      @cachely_fcns << fcn
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
