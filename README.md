# Cachely

Transparent method level caching using redis. Event machine optional.

## Usage

		class A 
			include Cachely
			
			cachely :foo
			
			def foo
				sleep(10)
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

Opts accepts keys :host, :port, :password, :driver. See redis-rb documentation for which drivers you want,
including whether or not you wish it to be evented.

I'd recommend doing this in a Rails initializer, or if you're using sinatra or other rack app, in config.ru.

If you want cached results to expire, instead of

		cachely :foo
		
use

		cachely :foo, time_to_expiry: 3.minutes
		
If you have a class method of the same name as an instance variable,

		cachely :foo
		
will still work, it will cache both the instance method foo and the class method foo, but in different
keyed locations, of course. To specify instance or class method, do

		cachely :foo, :type => "instance"
		cachely :foo, :type => "class"
		
Cachely is able to figure out whether or not to use the cache by looking at the arguments you pass in.
Generally, if your arguments are the same, and the object you're calling the method on is the same(Cachely uses 
the to_json method on the object you call the method on to determine this), then it assumes the result
will be the same and uses the cached result. 

CAVEAT: Do NOT use Cachely for functions that depend on time of day or random numbers, as these are inherently uncachable. 
If you check the tests out, you'll see random number functions are used exhaustively to test the caching ability of cachely,
because we know the function wasn't called if the second call yields the same number.

If you do not understand the implications of the caveat, do not use cachely. You're not ready yet. 
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
