module PaloAlto
  module Models
    class AddressGroup
      attr_accessor :name, :description, :addresses

      # Create and returns a new PaloAlto::Models::AddressGroup instance with the given parameters
      #
      # == Attributes
      #
      # * +name+        - Name of the address group
      # * +description* - Description for the address group
      #
      # == Example
      #
      #  PaloAlto::Models::AddressGroup.new name:        'address-group-1',
      #                                     description: 'address-group-1-description'
      def initialize(name:, description:, addresses: [])
        self.name        = name
        self.description = description
        self.addresses   = addresses

        self
      end
    end
  end
end
