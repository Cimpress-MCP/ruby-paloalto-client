module PaloAlto
  module Models
    class AddressGroup
      attr_accessor :name

      # Create and returns a new PaloAlto::Models::AddressGroup instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the address group
      #
      # == Example
      #
      #  PaloAlto::Models::AddressGroup.new name: 'address-group-1'
      def initialize(name:)
        self.name = name

        self
      end
    end
  end
end
