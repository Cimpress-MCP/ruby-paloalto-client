require "palo_alto/models/zone"

module PaloAlto
  module V6
    module ZoneApi
      # Parse out the zones from a response to query for zones
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::Zone instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def zones
        zone_list = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices/entry/vsys/entry/zone" }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining address XML" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        if data.xpath('//response/@status').to_s == "success"
          data.xpath('//response/result/zone/entry').each do |zone|
            zone_list << PaloAlto::Models::Zone.new(name: zone.xpath('@name').to_s)
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        zone_list
      end
    end
  end
end
