require 'fuzzy_gherkin/version'
require 'fuzzystringmatch'
require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'fuzzy_gherkin/comparitor'
require 'fuzzy_gherkin/io'
require 'json'
require 'pry'
require 'thor'

module FuzzyGherkin
  # Main Class to keep everything in for the time being
  class Main < Thor
  
    include FuzzyStringMatch
    include Gherkin

    desc "compare 'step', (0.00 to 1.00)[optional]", "Compares the step given to the other steps in all feature files"
    def compare(base_step = 'I press the latte button', threshold = 0.80)
      comparitor = Comparitor.new(base_step, threshold)
      comparitor.compare_all_steps_in_files
      io = IO.new(comparitor.base_step, comparitor.similar_steps)
      io.write_results
    end
  end
end
