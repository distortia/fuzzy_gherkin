# FuzzyGherkin

Fuzzy Matching Gherkin steps to show where potential similarities may exist and where code can be refactored or combined. *WIP*

## Installation

```ruby
gem install fuzzy_gherkin
```

## Usage

The gem is a command line app that will search for your feature files in the directory you run the command in. 
The output will be spit into a json file sorted by similarity %s. 

#### Optional Arguments

* --threshold [0.0-1.0] - specifies how similar you want the steps to be compared against. Defaults to 0.80.

```ruby 
fuzzy_gherkin --threshold 0.90 "Step you want to compare against"
```

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.com/u/distortia. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

