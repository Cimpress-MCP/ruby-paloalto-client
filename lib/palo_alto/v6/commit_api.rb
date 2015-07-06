require "crack/xml"

module PaloAlto
  module V6
    module CommitApi
      # Gets the status of a commit job based on the job ID
      #
      # == Parameters
      #
      # * +job_id+ - ID of the job that is performing the commit
      #
      # == Returns
      #
      # * +Boolean+ - True if job is complete, false if job is still processing
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the request is unsuccessful
      def commit_job_complete?(job_id:)
        status = false

        # get the job XML
        options           = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type => "op",
                              :cmd  => "<show><jobs><id>#{job_id}</id></jobs></show>",
                              :key  => self.auth_key }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining commit job XML" if html_result.nil?

        xml_data      = Nokogiri::XML(html_result)
        response_code = xml_data.xpath('//response/@status').to_s

        if response_code == "success"
          job_status = xml_data.xpath('//response/result/job/status')[0].content.to_s
          status = true if job_status == "FIN"
        else
          raise "Error in response XML: #{xml_data.inspect}"
        end

        status
      end

      # Gets the overall result and report for the commit job
      #
      # == Parameters
      #
      # * +job_id+ - ID of the job that performed the commit
      #
      # == Returns
      #
      # * +Hash+ - Hash containing the result of the commit job
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the request is unsuccessful
      def commit_job_result(job_id:)
        return Crack::XML.parse(get_job_xml(job_id: job_id).to_xml)
      end

      private

      # Retrieves the XML file for a given Job ID and returns the data in XML format
      #
      # == Parameters
      #
      # * +job_id+ - ID of the job to retrieve data for
      #
      # == Returns
      #
      # * +Nokogiri::XML::Document+ - XML data structure containing the response data from the job request
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the request is unsuccessful
      def get_job_xml(job_id:)
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type => "op",
                              :cmd  => "<show><jobs><id>#{job_id}</id></jobs></show>",
                              :key  => self.auth_key }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining log job XML" if html_result.nil?

        Nokogiri::XML(html_result)
      end
    end
  end
end
