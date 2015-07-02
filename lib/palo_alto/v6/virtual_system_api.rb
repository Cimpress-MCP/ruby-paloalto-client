require "palo_alto/models/virtual_system"
require "palo_alto/models/address"
require "palo_alto/models/address_group"
require "palo_alto/models/rulebase"

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
              # handle an optional 'description' parameter
              description   = (desc_xpath = address_group_entry.xpath('description')).empty? ? "" : desc_xpath.first.content
              address_group = PaloAlto::Models::AddressGroup.new(name:        address_group_entry.xpath('@name').to_s,
                                                                 description: description)

              # associate addresses with the address group
              address_group_entry.xpath('*/member').each do |address_entry|
                address_group.addresses << PaloAlto::Models::Address.new(name: address_entry.content, ip: "")
              end

              vsys.address_groups << address_group
            end

            # get all rulebase members for the virtual system
            # TODO: Expand beyond just the security rulebase
            vsys_entry.xpath('rulebase/security/rules/entry').each do |rulebase_entry|
              vsys.rulebases << PaloAlto::Models::Rulebase.new(name:              rulebase_entry.xpath('@name').to_s,
                                                               action:            (action = rulebase_entry.xpath('action')[0]) && action.content,
                                                               from_zones:        (from_zones = rulebase_entry.xpath('from/member')) && from_zones.map{ |z| z.content.strip },
                                                               to_zones:          (to_zones = rulebase_entry.xpath('to/member')) && to_zones.map{ |z| z.content.strip },
                                                               sources:           (sources = rulebase_entry.xpath('source/member')) && sources.map{ |z| z.content.strip },
                                                               destinations:      (destinations = rulebase_entry.xpath('destination/member')) && destinations.map{ |z| z.content.strip },
                                                               source_users:      (users = rulebase_entry.xpath('source-user/member')) && users.map{ |z| z.content.strip },
                                                               services:          (services = rulebase_entry.xpath('service/member')) && services.map{ |z| z.content.strip },
                                                               categories:        (categories = rulebase_entry.xpath('category/member')) && categories.map{ |z| z.content.strip },
                                                               applications:      (applications = rulebase_entry.xpath('application/member')) && applications.map{ |z| z.content.strip },
                                                               hip_profiles:      (profiles = rulebase_entry.xpath('hip_profiles/member')) && profiles.map{ |z| z.content.strip },
                                                               log_session_start: (log_start = rulebase_entry.xpath('log-start')[0]) && log_start.content || "no",
                                                               log_session_end:   (log_end = rulebase_entry.xpath('log-end')[0]) && log_end.content || "no")
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
