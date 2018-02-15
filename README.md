# ActsAsMergeable
Merge two `ActiveRecord` instances of the same class, with preference to the main instance on which the `merge` method is called on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_mergeable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_mergeable

## Usage

Adding `acts_as_mergeable` to your `ActiveRecord` class gives instances of the class access to a `merge` method, which can be used to merge in another instance of the same class by accepting the second instance as an argument.

E.g: Given an `ActiveRecord` `User` class

```ruby
class User < ActiveRecord::Base
	acts_as_mergeable
end
```
If `active_user` and `inactive_user` are two instances of the `User` class, attributes and associations of `inactive_user` can be merged into `active_user` by calling `active_user.merge(inactive_user)`

#####NOTE: Preference is always given to properties of the main/parent instance.
```ruby
	> active_user = User.create(name: 'John Doe', email: 'john@doe.com')
	> inactive_user = User.create(name: '', email: 'previous.john@doe.com', alias: 'jon D doe')
	
	# merge inactive_user into active_user
	> active_user.merge(inactive_user)
	
	# active user now has attributes (and associated relationships) of the inactive user
	> active_user.name
	  => 'John Doe'
	> active_user.email
	  => 'john@doe.com'
	> active_user.alias
	  => 'jon D doe'
```

An optional `destroy: true` can be passed to the call to `merge`. Setting this will ensure the destroyal of the `merged` instance.

 ```ruby
  > main_account = User.create(name: 'John Doe')
  > other_account = User.create(name: 'Other User')
  
  # merge other_account into main_account, specifying "destroy: true"
  > main_account.merge(other_account, {destroy: true})
  
  # Looking for the "other_account" record yields nothing as it has been deleted
  > User.find_by_id(other_account.id)
    => nil
  > User.find_by_id(main_account.id)
  	=> #<User id: 1, name: 'John Doe', ...>
 ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `rake console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/acts_as_mergeable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActsAsMergeable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/acts_as_mergeable/blob/master/CODE_OF_CONDUCT.md).
