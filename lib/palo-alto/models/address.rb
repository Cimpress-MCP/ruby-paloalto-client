module PaloAlto
  module Models
    class Address
      attr_accessor :name, :ip

      # Create and returns a new PaloAlto::Models::Address instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the address
      # * +ip+   - IP of the address
      #
      # == Example
      #
      #  PaloAlto::Models::Address.new name: 'address-1',
      #                                ip:   '2.2.2.2'
      def initialize(name:, ip:)
        self.name = name
        self.ip   = ip

        self
      end
    end
  end
end
