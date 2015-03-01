module PaloAlto
  module Models
    # Currently, Rulebase is a stand-in for "Security"
    # TODO: Add different Rulebase types (Security, NAT, etc)
    class Rulebase
      attr_accessor :name

      # Create and returns a new PaloAlto::Models::Rulebase instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the rulebase
      #
      # == Example
      #
      #  PaloAlto::Models::Rulebase.new name: 'rulebase-1'
      def initialize(name:)
        self.name = name

        self
      end
    end
  end
end
