require "palo_alto/v6/device_api"
require "palo_alto/v6/virtual_system_api"
require "palo_alto/v6/address_api"
require "palo_alto/v6/address_group_api"
require "palo_alto/v6/log_api"
require "palo_alto/v6/security_rule_api"
require "palo_alto/v6/commit_api"
require "palo_alto/v6/zone_api"
require "palo_alto/v6/job_api"

module PaloAlto
  module V6
    class Api < Common::BaseApi
      # include required APIs for functionality
      include PaloAlto::V6::DeviceApi
      include PaloAlto::V6::VirtualSystemApi
      include PaloAlto::V6::AddressApi
      include PaloAlto::V6::AddressGroupApi
      include PaloAlto::V6::LogApi
      include PaloAlto::V6::SecurityRuleApi
      include PaloAlto::V6::CommitApi
      include PaloAlto::V6::ZoneApi
      include PaloAlto::V6::JobApi


      # Request a configuration based on the starting XML path.
      #
      # == Returns
      #
      #  * +Nokogiri::XML::Document+ - Nokogiri XML document to parse information about
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def xml_config_for(path:)
        virtual_systems_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  path }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining virtual system XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)
        raise "Error in response XML: #{data.inspect}" if data.xpath('//response/@status').to_s != "success"
        data
      end
    end
  end
end
