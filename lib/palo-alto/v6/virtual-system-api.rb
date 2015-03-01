require "palo-alto/models/virtual-system"
require "palo-alto/models/address"
require "palo-alto/models/address-group"
require "palo-alto/models/rulebase"

module PaloAlto
  module V6
    module VirtualSystemApi
      # Parse out the virtual systems from a response to query for virtual systems
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::VirtualSystem instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def virtual_systems
        virtual_systems_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices/entry/vsys" }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining virtual system XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        if data.xpath('//response/@status').to_s == "success"
          data.xpath('//response/result/vsys/entry').each do |vsys_entry|
            vsys = PaloAlto::Models::VirtualSystem.new(name: vsys_entry.xpath('@name').to_s)

            # get all address members for the virtual system
            vsys_entry.xpath('address/entry').each do |address_entry|
              vsys.addresses << PaloAlto::Models::Address.new(name: address_entry.xpath('@name').to_s,
                                                              ip:   address_entry.xpath('ip-netmask').first.content)
            end

            # get all address group members for the virtual system
            vsys_entry.xpath('address-group/entry').each do |address_group_entry|
              address_group = PaloAlto::Models::AddressGroup.new(name:        address_group_entry.xpath('@name').to_s,
                                                                 description: address_group_entry.xpath('description').first.content)

              # associate addresses with the address group
              address_group_entry.xpath('*/member').each do |address_entry|
                address_group.addresses << PaloAlto::Models::Address.new(name: address_entry.content, ip: "")
              end

              vsys.address_groups << address_group
            end

            # get all rulebase members for the virtual system
            # TODO: Expand beyond just the security rulebase
            vsys_entry.xpath('rulebase/security/rules/entry').each do |rulebase_entry|
              vsys.rulebases << PaloAlto::Models::Rulebase.new(name: rulebase_entry.xpath('@name').to_s)
            end

            virtual_systems_list << vsys
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        virtual_systems_list
      end
    end
  end
end
