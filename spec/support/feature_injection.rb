# WIP, will add and squash
module BDD

  def self.inject
    BDD::FeatureInjection.instance
  end

  class FeatureInjection
    include Singleton
    def uic(s, *metadata, &example_group_block)
      data = get_data(*metadata, &example_group_block)
      s_vision = format('Vision', data['vision'])
      RSpec::describe(s_vision, *metadata) do
        goal data['goal'] do
          capability data['capability'] do
            uic s, type: :feature, &example_group_block
          end
        end
      end
    end

    def api(s, *metadata, &example_group_block)
      data = get_data(*metadata, &example_group_block)
      s_vision = format('Vision', data['vision'])
      RSpec::describe(s_vision, *metadata) do
        goal data['goal'] do
          capability data['capability'] do
            api s, type: :request, &example_group_block
          end
        end
      end
    end

    def get_data(*metadata, &example_group_block)
      data = Hash.new("-")

      # data = LOAD bdd.yml files from parent folders into
      p = Pathname(example_group_block.source_location.first)
      # data['feature'] = s
      loop do
        break if p.to_s.ends_with? '/spec'
        r = p.join('bdd.yml')
        data.reverse_merge!(YAML.load_file(r)) if r.exist?
        p = p.parent
      end
      data
    end

    def format(s1, s2)
      [s1.underline.light_white, s2].join(": ")
    end
  end

  module RSpec
    module ExampleGroups
      def the_context(s, *args, &b)
        context(BDD.inject.format("Context", s), *args, &b)
      end

      def vision(s, *args, &b)
        context(BDD.inject.format("Vision", s), *args, &b)
      end

      def goal(s, *args, &b)
        context(BDD.inject.format("Goal", s), *args, &b)
      end

      def capability(s, *args, &b)
        context(BDD.inject.format("Capability", s), *args, &b)
      end

      # def feature(s, *args, &b)
      #   context(BDD.inject.format("Feature", s), *args, &b)
      # end

      # need opinions
      def api(s, *args, &b)
        context(BDD.inject.format("Feature/API", s), *args, &b)
      end

      # need opinions
      def uic(s, *args, &b)
        context(BDD.inject.format("Feature/UI Component", s), *args, &b)
      end

      def story(s, *args, &b)
        context(BDD.inject.format("Story", s), *args, &b)
      end

      def scenario(s, *args, &b)
        super(BDD.inject.format("Scenario", s), *args, &b)
      end

    end
  end
end

RSpec.configure do |config|
  config.extend BDD::RSpec::ExampleGroups
end
