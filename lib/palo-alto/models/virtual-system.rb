module PaloAlto
  module Models
    class VirtualSystem
      attr_accessor :name

      # Create and returns a new PaloAlto::Models::VirtualSystem instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the virtual system
      #
      # == Example
      #
      #  PaloAlto::Models::VirtualSystem.new name: 'vsys-1'
      def initialize(name:)
        self.name = name

        self
      end
    end
  end
end
