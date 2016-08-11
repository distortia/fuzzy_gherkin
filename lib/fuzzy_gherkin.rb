require 'fuzzy_gherkin/version'
require 'fuzzystringmatch'
require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'json'

module FuzzyGherkin
  # Main Class to keep everything in for the time being
  class Main
    include FuzzyStringMatch
    include Gherkin

    attr_accessor :threshold, :fsm, :similar_steps, :base_step

    def initialize(base_step = 'I press the latte button', threshold = 0.80)
      @threshold = threshold.to_f
      @similar_steps = []
      @base_step = base_step
      @fsm = FuzzyStringMatch::JaroWinkler.create(:pure)
    end

    def parse_feature(feature_file = 'example.feature')
      parser = Gherkin::Parser.new
      # need a way to get the feature file directory
      # and load all feature files in directory
      feature_path = File.expand_path(File.dirname(__FILE__)) + "/fuzzy_gherkin/#{feature_file}"
      raise "FAILURE: File not found at #{feature_path}" unless File.file?(feature_path)
      gherkin_document = parser.parse(File.read(feature_path))
      # Filter out the backgrounds of the scenarios
      # returns list of scenarios
      # gherkin_document[:feature][:children].map! { |step| step unless step[:type].eql? :Background }.compact
      gherkin_document[:feature][:children].map! { |step| step }.compact
    end

    def compare(comparing_step)
      puts "comparing_step #{comparing_step}"
      distance = @fsm.getDistance(@base_step, comparing_step)
      puts "distance: #{distance}"
      # 1.0 is a perfect match.
      # This means its a repeated step and we can ignore.
      if distance >= @threshold && distance != 1.0
        @similar_steps << "#{(distance * 100).round(2)}% - " + comparing_step
      else
        distance
      end
    end

    def compare_all_steps_in_scenario(scenario)
      scenario[:steps].each do |step|
        compare(step[:text])
      end
    end

    def compare_base_to_all_scenarios_in_file(scenarios)
      scenarios.each do |scenario|
        compare_all_steps_in_scenario(scenario)
      end
    end

    def format_similar_steps_hash
      { @base_step => @similar_steps.uniq }
    end

    def write_results
      file_name = 'results.json'
      f = File.new(file_name, 'w+')
      f.write(JSON.pretty_generate(format_similar_steps_hash))
      f.close
      puts "Writing results to file: #{file_name}"
    end

    def do_everything
      all_scenarios = parse_feature
      compare_base_to_all_scenarios_in_file(all_scenarios)
      write_results
    end
  end
end
