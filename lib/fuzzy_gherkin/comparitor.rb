module FuzzyGherkin
    class Comparitor

        attr_accessor :threshold, :fsm, :similar_steps, :base_step, :all_steps

        def initialize(base_step, threshold)
          @threshold = threshold.to_f
          @similar_steps = []
          @base_step = base_step
          @all_steps = []
          @fsm = FuzzyStringMatch::JaroWinkler.create(:pure)
        end

        def all_feature_files
          Dir['**/*.feature']
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
            start_time = Time.now
            all_steps_in_files.each do |step|
                compare_step_to_base_step(step)
            end
            end_time = Time.now
            puts "Comparison ended after #{end_time - start_time} seconds!"
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
            puts "Comparing base step to: '#{comparing_step}'"
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
    end
end