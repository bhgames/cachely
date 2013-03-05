# Cachely

Transparent method level caching using redis. Event machine optional.

## Usage

		class A 
			include Cachely
			
			cachely :foo
			
			def foo
				sleep(10) #Simulate blocking with a 10s sleep. Could be an ARModel.all command? An API call?
				return rand(500) #Holy moly, what a HUGE, LONG CALL! Returns a different value every time.
			end
		
		end
		
		a = A.new
		
		start = Time.now
		result_1 = a.foo
		after = Time.now
		time_1 = after-start
		
		start = Time.now
		result_2 = a.foo #Now it uses the redis cache.
		after = Time.now
		time_2 = after-start
		
		p "First call took #{time_1}"
		
		p "Second call took #{time_2}"
		
		p "Results equal? #{result_2 == result_1}. Of course! It cached the output."
		
		=> "First call took 10.031092"
		=> "Second call took 0.032047"
		=> "Results equal? true. Of course! It cached the output."
		

In order to make this work, you must connect to a redis store using the method:

		Cachely::Mechanics.connect(opts = {})

Opts accepts keys :host, :port, :password, :driver, and :logging. See redis-rb documentation for which drivers you want,
including whether or not you wish it to be evented. The :logging key is cachely only, it turns on performance logging.

I'd recommend doing this in a Rails initializer, or if you're using sinatra or other rack app, in config.ru.

If you want cached results to expire, instead of

		cachely :foo
		
use

		cachely :foo, time_to_expiry: 3.minutes
		
If you have a class method of the same name as an instance method,

		cachely :foo
		
will still work, it will cache both the instance method foo and the class method foo, but in different
keyed locations, of course. To specify instance or class method, do

		cachely :foo, :type => "instance"
		cachely :foo, :type => "class"	

Cachely is able to figure out whether or not to use the cache by looking at the arguments you pass in.
Generally, if your arguments are the same, and the object you're calling the method on is the same(Cachely uses 
the to_json method on the object you call the method on to determine this), then it assumes the result
will be the same and uses the cached result.

Cachely expects that any objects you return or pass in to methods as arguments have to_json methods. Without
this, it won't work. 

Because of this, you can expire method results by their "signatures", that is, the object the method is being called on,
the method name, and it's arguments. To expire a cached result by this signature, call

    Cachely::Mechanics.expire(object, method, *args)

Want to wipe all keys?

    Cachely::Mechanics.flush_all_keys

And done.

## to_json, the all important method

Cachely relies on the to_json method of objects extensively to work. ActiveRecord to_json methods are supported, as well as to_jsons
on primitives and what not. If you deign to write your own to_json for your objects, including ARs, good for you, you should. But you should know
that cachely works partially by instantiating a new instance of your class and calling to_json on it without setting any associations. So, if your to_json method is

    def to_json
      {
        "stuff": self.stuff.id
      }.to_json
    end

Where stuff is some kind of association, it will destroy cachely, because when cachely instantiates this new object with no fields just to get a look at it's field structure,
it's going to call id on a nil class(stuff is unset.) So think about this when you write to_json methods. I can't protect you from your own stupidity, you really should
be checking for nilness before you call id. I recommend the gem andand.

## Caveats

CAVEAT 1: Do NOT use Cachely for functions that depend on time of day or random numbers, as these are inherently uncachable. 
If you check the tests out, you'll see random number functions are used exhaustively to test the caching ability of cachely,
because we know the function wasn't called if the second call yields the same number.

If you do not understand the implications of the caveat, do not use cachely. You're not ready yet. 

CAVEAT 2: Do NOT use Cachely on a method that you pass arguments with circular references to themselves, ie 

    hash = {}
    hash[:hash] = hash
    hash.to_json #will throw an error, to_json is used exhaustively by cachely to handle caching properly.

This also includes method results - if you ever return a result that has circular references, don't use cachely. If the object or class you're calling the method on
has circular references to itself, don't use cachely then, either.

One exception is ActiveRecord objects, which have already been fixed in this regard. There are three tests in conversion_tests.rb that fail still that deal with this
caveat. I'll be fixing them in the future and we'll be one caveat shorter.

CAVEAT 3: Do not use Cachely if you are altering arguments that you pass into the method. Cachely isn't running the method if it has a response already stored, so obviously your argument will remain unchanged. I guess I could add support for this in the future, but this is a bit of a complex, nuanced addition and I'd rather not worry about it now. 

CAVEAT 4: Do not use on functions that return ActiveRecord::Relation objects, or use them as arguments. They can't be instantiated normally and I haven't added support for them yet. I have added two tests for them, and they still fail. So if you can write a fix, and it passes these tests, go for it!

## Installation

Add this line to your application's Gemfile:

    gem 'cachely'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cachely

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
