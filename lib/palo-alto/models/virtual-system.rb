module PaloAlto
  module Models
    class VirtualSystem
      attr_accessor :name, :addresses, :address_groups, :rulebases

      # Create and returns a new PaloAlto::Models::VirtualSystem instance with the given parameters
      #
      # == Attributes
      #
      # * +name+           - Name of the virtual system
      # * +addresses+      - Array of Model::Address instances
      # * +address_groups+ - Array of Model::AddressGroup instances
      # * +rulebases+      - Array of Model::Rulebase instances
      #
      # == Example
      #
      #  PaloAlto::Models::VirtualSystem.new name: 'vsys-1'
      def initialize(name:, addresses: [], address_groups: [], rulebases: [])
        self.name           = name
        self.addresses      = addresses
        self.address_groups = address_groups
        self.rulebases      = rulebases

        self
      end
    end
  end
end
