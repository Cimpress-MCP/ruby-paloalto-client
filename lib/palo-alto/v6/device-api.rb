require "palo-alto/models/device"
require "palo-alto/models/virtual-system"

module PaloAlto
  module V6
    module DeviceApi
      # Parse out the devices from a response to query for devices
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::Device instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def devices
        devices_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices" }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining device XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        if data.xpath('//response/@status').to_s == "success"
          data.xpath('//response/result/devices/entry').each do |device_entry|
            device = PaloAlto::Models::Device.new(name: device_entry.xpath('@name').to_s,
                                                  ip:   device_entry.xpath('deviceconfig/system/ip-address').first.content)

            # get all virtual_system members for the device
            device_entry.xpath('vsys/entry').each do |vsys_entry|
              device.virtual_systems << PaloAlto::Models::VirtualSystem.new(name: vsys_entry.xpath('@name').to_s)
            end

            devices_list << device
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        devices_list
      end
    end
  end
end
