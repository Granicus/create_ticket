# CreateTicket

Create JIRA tickets from ERB Markdown files. For an example, see `test/fixtures/example.md.erb`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'create_ticket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install create_ticket

## Usage

    export JIRA_TOKEN="your JIRA token"
    export TEMPLATE_FILENAME=a-template.md.erb
    export JIRA_URL=https://jira.yourwebsite.com
    export JIRA_PROJECT=YOURPROJECT
    export JIRA_ASSIGNEE=`whoami`
    export JIRA_ISSUE_TYPE=Story

    export JIRA_CUSTOMFIELD_12345="If you have a required custom field, you can set them like this."

    create_ticket

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/govdelivery/create_ticket. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CreateTicket project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/create_ticket/blob/master/CODE_OF_CONDUCT.md).
