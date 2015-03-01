require "palo_alto/models/address"

module PaloAlto
  module V6
    module AddressApi
      # Parse out the addresses from a response to query for addresses
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::Address instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def addresses
        address_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices/entry/vsys/entry" }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining address XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        if data.xpath('//response/@status').to_s == "success"
          data.xpath('//response/result/entry/address/entry').each do |address|
            address_list << PaloAlto::Models::Address.new(name: address.xpath('@name').to_s, ip: address.xpath('ip-netmask').first.content)
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        address_list
      end
    end
  end
end
