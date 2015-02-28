module PaloAlto
  module Models
    class Policy
      attr_accessor :name

      # Create and returns a new PaloAlto::Models::Policy instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the policy
      #
      # == Example
      #
      #  PaloAlto::Models::Policy.new name: 'policy-1'
      def initialize(name:)
        self.name = name

        self
      end
    end
  end
end
