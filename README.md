# RootineGem

Explore root in word.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rootine-gem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rootine-gem

## Usage

```ruby
info = rootine.get_word_roots('telecommuter')
# => [[0, 4, [331]], [4, 7, [64]], [7, 10, [215]], [10, 12, [38, 39, 40]]]
rootine.roots[info[0][2][0]]
# => ["^tel[eo]?", "tel/e/o", "far, distant, complete", "遠く、遠く、完全な", "Greek", "telephone - a device to talk to a distant person; telescope - a device to view distant objects; television - a device to receive pictures from afar; telecommuting - working remotely, bridging the distance via virtual devices."]
```

result ::= root_info, suffix_info
root_info ::= [] | [root_start_at, root_end_at, regexp_indexes] | root_info, root_info
suffix_info ::= [] | [root_start_at, root_end_at, regexp_indexes]
root_start_at ::= number (0 <= i <= word.length)
root_end_at ::= number (0 <= i <= word.length)
regexp_indexes ::= regexp_index | regexp_indexes, regexp_index
regexp_index ::= number

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sa2taka/rootine-gem.
