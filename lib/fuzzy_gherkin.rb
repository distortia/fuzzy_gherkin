require 'fuzzy_gherkin/version'
require 'fuzzystringmatch'
require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'json'
require 'pry'

module FuzzyGherkin
  # Main Class to keep everything in for the time being
  class Main
    include FuzzyStringMatch
    include Gherkin

    attr_accessor :threshold, :fsm, :similar_steps, :base_step, :features_directory, :all_steps

    def initialize(base_step = 'I press the latte button', threshold = 0.80)
      @threshold = threshold.to_f
      @similar_steps = []
      @base_step = base_step
      @all_steps = []
      @fsm = FuzzyStringMatch::JaroWinkler.create(:pure)
    end

    # Directory should be project directory starting with /
    # Example: /features/scenarios
    def features_directory(directory = '/fuzzy_gherkin/')
      @features_directory = File.expand_path(File.dirname(__FILE__)) + directory
    end

    def all_feature_files
      Dir[@features_directory + '**/*.feature']
    end

    def all_steps_in_files
      all_steps = []
      all_feature_files.each do |file|
        scenarios = parse_feature_file(file)
        scenarios.each do |scenario|
          all_steps << scenario[:steps].map! { |step| step[:text] }
        end
      end
      all_steps.flatten.uniq
    end

    def compare_all_steps_in_files
      all_steps_in_files.each do |step|
        compare_step_to_base_step(step)
      end
    end

    # Returns background and sceanrios in feature file
    def parse_feature_file(feature_file)
      parser = Gherkin::Parser.new
      raise "FAILURE: File not found at #{feature_path}" unless File.file?(feature_file)
      gherkin_document = parser.parse(File.read(feature_file))
      gherkin_document[:feature][:children]
    end

    # Compares the given step to the base step
    def compare_step_to_base_step(comparing_step)
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

    # {
    #   "base-step" : [
    #     "first.feature" : [
    #       "matching % - step that matches base"
    #     ],
    #     "second.feature" : [
    #       "matching % - step that matches base"
    #     ]
    #   ]
    # }
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
      features_directory
      compare_all_steps_in_files
      write_results
    end
  end
end
