require "palo_alto/models/address_group"
require "palo_alto/models/address"

module PaloAlto
  module V6
    module AddressGroupApi
      # Parse out the address groups from a response to query for address groups
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::AddressGroup instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def address_groups
        address_group_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices/entry/vsys/entry" }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining address group XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        if data.xpath('//response/@status').to_s == "success"
          data.xpath('//response/result/entry/address-group/entry').each do |address_group_entry|
            address_group = PaloAlto::Models::AddressGroup.new(name:        address_group_entry.xpath('@name').to_s,
                                                               description: address_group_entry.xpath('description').first.content)

            # get all address members for the address group
            address_group_entry.xpath('*').each do |address_entry|
              if (specific_address = address_entry.xpath('member')).length > 0
                address_group.addresses << PaloAlto::Models::Address.new(name: specific_address[0].content, ip: "")
              end
            end

            address_group_list << address_group
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        address_group_list
      end
    end
  end
end
