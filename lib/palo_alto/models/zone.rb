module PaloAlto
  module Models
    class Zone
      attr_accessor :name

      # Create and returns a new PaloAlto::Models::Zone instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the zone
      #
      # == Example
      #
      #  PaloAlto::Models::Zone.new name: 'ingress'
      def initialize(name:)
        self.name = name

        self
      end
    end
  end
end
