require "palo_alto/models/log_entry"

module PaloAlto
  module V6
    module LogApi
      MIN_LOG_REQUEST = 20
      MAX_LOG_REQUEST = 5000

      # Kicks off a job to generate logs asynchronously
      #
      # == Parameters
      #
      #  * +log_type+ - Type of log to generate
      #  * +num_logs+ - Number of log entries to query for (check MIN/MAX range for specifics)
      #
      # == Returns
      #
      #  * +String+ - String containing the Job ID
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful or an
      #                  invalid log_type parameter is passed
      def generate_logs(log_type:, num_logs: MIN_LOG_REQUEST)
        raise "Invalid log_type - must be one of #{PaloAlto::Models::LogEntry::SUPPORTED_TYPES}" unless PaloAlto::Models::LogEntry::SUPPORTED_TYPES.include?(log_type)
        raise "num_logs must be within range (#{MIN_LOG_REQUEST}..#{MAX_LOG_REQUEST})" unless (MIN_LOG_REQUEST..MAX_LOG_REQUEST) === num_logs

        log_job_id = ''

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type       => "log",
                              :'log-type' => log_type,
                              :key        => self.auth_key,
                              :nlogs      => num_logs.to_s }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining log job XML" if html_result.nil?

        # parse the XML data
        data          = Nokogiri::XML(html_result)
        response_code = data.xpath('//response/@status').to_s

        if response_code == "success"
          log_job_id = data.xpath('//response/result/job')[0].content.to_s
        else
          raise "Error in response XML: #{data.inspect}"
        end

        log_job_id
      end

      # Gets the status of a log job based on the Job ID
      #
      # == Parameters
      #
      # * +job_id+ - ID of the job that is generating the logs
      #
      # == Returns
      #
      # * +Boolean+ - True if job is complete, false if job is still processing
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the request is unsuccessful
      def log_job_complete?(job_id:)
        status        = false
        xml_data      = get_log_xml(job_id: job_id)
        response_code = get_log_xml_response_code(xml_data: xml_data)

        if response_code == "success"
          job_status = get_log_job_status(xml_data: xml_data)
          status = true if job_status == "FIN"
        else
          raise "Error in response XML: #{data.inspect}"
        end

        status
      end

      # Gets a set of logs based on the Job ID
      #
      # == Parameters
      #
      #  * +job_id+ - ID of the job that generated the logs
      #
      # == Returns
      #
      #  * +Array+ - Array of Strings that are the log messages
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def get_logs(job_id:)
        logs          = []
        xml_data      = get_log_xml(job_id: job_id)
        response_code = get_log_xml_response_code(xml_data: xml_data)

        if response_code == "success"
          job_status = get_log_job_status(xml_data: xml_data)

          if job_status == "FIN"
            xml_data.xpath('//response/result/log/logs/*').each do |log_xml|
              logs << PaloAlto::Models::LogEntry.from_xml(xml_data: log_xml)
            end
          else
            raise "Log job with ID '#{job_id}' is still in progress"
          end
        else
          raise "Error in response XML: #{data.inspect}"
        end

        logs
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
      def get_log_xml(job_id:)
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type     => "log",
                              :action   => :get,
                              :'job-id' => job_id,
                              :key      => self.auth_key }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining log job XML" if html_result.nil?

        Nokogiri::XML(html_result)
      end

      # Retrieves the response code from an XML data object
      #
      # == Parameters
      #
      # * +xml_data+ - Nokogiri::XML::Document object containing the XML data to parse
      #
      # == Returns
      #
      # * +String+ - String containing the response code returned in the XML data
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the input data is not a valid Nokogiri::XML::Document
      def get_log_xml_response_code(xml_data:)
        raise "xml_data must be a valid Nokogiri::XML::Document type" unless xml_data.is_a?(Nokogiri::XML::Document)
        xml_data.xpath('//response/@status').to_s
      end

      # Retrieves the job status from an XML data object
      #
      # == Parameters
      #
      # * +xml_data+ - Nokogiri::XML::Document object containing the XML data to parse
      #
      # == Returns
      #
      # * +String+ - String containing the job status returned in the XML data
      #
      # == Raises
      #
      # * +Exception+ - Raises an exception if the input data is not a valid Nokogiri::XML::Document
      def get_log_job_status(xml_data:)
        raise "xml_data must be a valid Nokogiri::XML::Document type" unless xml_data.is_a?(Nokogiri::XML::Document)
        xml_data.xpath('//response/result/job/status')[0].content.to_s
      end
    end
  end
end
