module PaloAlto
  module Models
    class Device
      attr_accessor :name, :ip

      # Create and returns a new PaloAlto::Models::Device instance with the given parameters
      #
      # == Attributes
      #
      # * +name+ - Name of the address group
      # * +ip+   - Device IP address
      #
      # == Example
      #
      #  PaloAlto::Models::Device.new name: 'device-1',
      #                               ip:   '1.2.3.4'
      def initialize(name:, ip:)
        self.name = name
        self.ip   = ip

        self
      end
    end
  end
end
