# ExceptionHunter
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add Exception Hunter to your application's Gemfile:

```ruby
gem 'exception_hunter', '~> 0.1.1'
```

You may also need to add [Devise](https://github.com/heartcombo/devise) to your Gemfile
if you haven't already done so and plan to use the gem's built in authentication:

```ruby
gem 'devise'
```

After installing the dependencies you'll want to run:

```bash
$ rails generate exception_hunter:install
```

This will create an initializer and invoke Devise to
create an `AdminUser` which will be used for authentication to access the dashboard. If you already
have this user created (Devise uses the same model) you can run the command with the `--skip-users` flag.

Additionally it should add the 'ExceptionHunter.routes(self)' line to your routes, which means you can go to
`/exception_hunter/errors` in your browser and start enjoying some good old fashioned exception tracking!

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Exception Hunter is maintained by [Rootstrap](http://www.rootstrap.com) with
the help of our [contributors](https://github.com/rootstrap/exception_hunter/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
