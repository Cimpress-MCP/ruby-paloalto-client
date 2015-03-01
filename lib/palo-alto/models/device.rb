module PaloAlto
  module Models
    class Device
      attr_accessor :name, :ip, :virtual_systems

      # Create and returns a new PaloAlto::Models::Device instance with the given parameters
      #
      # == Attributes
      #
      # * +name+            - Name of the device
      # * +ip+              - Device IP address
      # * +virtual_systems+ - Array containing Model::VirtualSystem instances
      #
      # == Example
      #
      #  PaloAlto::Models::Device.new name: 'device-1',
      #                               ip:   '1.2.3.4'
      def initialize(name:, ip:, virtual_systems: [])
        self.name            = name
        self.ip              = ip
        self.virtual_systems = virtual_systems

        self
      end
    end
  end
end
