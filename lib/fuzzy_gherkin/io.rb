module FuzzyGherkin
    class IO 
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

        def initialize(base_step, similar_steps)
            @base_step = base_step
            @similar_steps = similar_steps
        end

        def format_similar_steps_hash
          { @base_step => @similar_steps.uniq.sort.reverse }
        end

        def write_results
          file_name = 'results.json'
          f = File.new(file_name, 'w+')
          f.write(JSON.pretty_generate(format_similar_steps_hash))
          f.close
          puts "Writing results to file: #{file_name}"
        end
    end
end