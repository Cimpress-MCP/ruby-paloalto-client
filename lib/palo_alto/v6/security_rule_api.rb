require "crack/xml"
require "palo_alto/models/rulebase"

module PaloAlto
  module V6
    module SecurityRuleApi
      # Get a security rule with the given name (if exists)
      #
      # == Inputs
      #
      # * +name+ - Name of the rule to query for
      #
      # == Returns
      #
      # * +JSON+ - JSON data containing the rule found
      #
      # == Raises
      #
      # * +Exception+ - Exception if there is a communication/other issue
      #
      # == TODO
      #
      # * Eventually this function should be changed to return an actual PaloAlto::Models::Rulebase
      #    object instance rather than JSON to be more consistent with library function.
      def get_security_rule(name:)
        xpath_search = "/config/devices/entry/vsys/entry/rulebase/security/rules/entry[@name='#{name}']"

        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  xpath_search }

        # attempt to perform the query
        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining XML" if html_result.nil?

        # parse the XML data
        data          = Nokogiri::XML(html_result)
        response_code = data.xpath('//response/@status').to_s

        if response_code == "success"
          if (rule_elements = data.xpath('//response/result/entry')).length > 0
            return Crack::XML.parse(rule_elements[0].to_xml)
          else
            return nil
          end
        else
          return nil
        end
      end

      # Create a security rule (firewall rule)
      #
      # == Returns
      #
      #  * +Hash+ - Hash of a Model::Rulebase instance
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def create_security_rule(rule_hash:)
        # construct the XML elements for the request
        element_xpath = "/config/devices/entry/vsys/entry/rulebase/security/rules/entry[@name='#{rule_hash[:name]}']"

        element_value  = "<action>"       + rule_hash[:action]                                                               + "</action>"
        element_value += "<from>"         + rule_hash[:from_zones].split(',').map{ |e| "<member>#{e}</member>" }.join        + "</from>"
        element_value += "<to>"           + rule_hash[:to_zones].split(',').map{ |e| "<member>#{e}</member>" }.join          + "</to>"
        element_value += "<source>"       + rule_hash[:sources].split(',').map{ |e| "<member>#{e}</member>" }.join           + "</source>"       if rule_hash[:sources]
        element_value += "<destination>"  + rule_hash[:destinations].split(',').map{ |e| "<member>#{e}</member>" }.join      + "</destination>"  if rule_hash[:destinations]
        element_value += "<source-user>"  + rule_hash[:source_users].split(',').map{ |e| "<member>#{e}</member>" }.join      + "</source-user>"  if rule_hash[:source_users]
        element_value += "<service>"      + rule_hash[:services].split(',').map{ |e| "<member>#{e}</member>" }.join          + "</service>"      if rule_hash[:services]
        element_value += "<category>"     + rule_hash[:categories].split(',').map{ |e| "<member>#{e}</member>" }.join        + "</category>"     if rule_hash[:categories]
        element_value += "<application>"  + rule_hash[:applications].split(',').map{ |e| "<member>#{e}</member>" }.join      + "</application>"  if rule_hash[:applications]
        element_value += "<hip-profiles>" + rule_hash[:hip_profiles].split(',').map{ |e| "<member>#{e}</member>" }.join      + "</hip-profiles>" if rule_hash[:hip_profiles]
        element_value += "<log-start>"    + rule_hash[:log_session_start]                                                    + "</log-start>"    if rule_hash[:log_session_start]
        element_value += "<log-end>"      + rule_hash[:log_session_end]                                                      + "</log-end>"      if rule_hash[:log_session_end]

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:    "config",
                              action:  "set",
                              key:     self.auth_key,
                              xpath:   element_xpath,
                              element: element_value }

        html_result = Helpers::Rest.make_request(options)

        raise "Error during security rule create" if html_result.nil?

        # parse the XML data
        data = Nokogiri::XML(html_result)

        # check that the operation was successful
        if data.xpath('//response/@status').to_s == "success"
          # commit the change to be operational
          # TODO: Should probably do partial commit once device IDs are built in
          options = {}
          options[:url]     = self.endpoint
          options[:method]  = :post
          options[:payload] = { type:    "commit",
                                key:     self.auth_key,
                                cmd:   "<commit></commit>" }

          html_result = Helpers::Rest.make_request(options)

          raise "Error during security rule commit" if html_result.nil?

          # parse the XML data
          data = Nokogiri::XML(html_result)

          # check that the operation was successful and return the job ID
          if data.xpath('//response/@status').to_s == "success"
            return data.xpath('//response/result/job')[0].content.to_s
          else
            raise "#{Crack::XML.parse(data.to_xml)}"
          end
        else
          raise "#{Crack::XML.parse(data.to_xml)}"
        end
      end
    end
  end
end
