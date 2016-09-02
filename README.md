# FuzzyGherkin

Fuzzy Matching Gherkin steps to show where potential similarities may exist and where code can be refactored or combined. *WIP*

## Installation

```ruby
gem install fuzzy_gherkin
```

## Usage

The gem is a command line app that will search for your feature files in the directory you run the command in. 
The output will be spit into a json file sorted by similarity %s. 

The compare command is broken into two parts, the base step and the threshold. Threshold will default to 0.80.

```ruby 
fuzzy_gherkin compare "Step you want to compare against", 0.85
```

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.com/u/distortia. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

