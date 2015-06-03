require "palo_alto/models/log_entry"

module PaloAlto
  module V6
    module LogApi
      MIN_LOG_REQUEST = 20
      MAX_LOG_REQUEST = 2000

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
        logs = []

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type     => "log",
                              :action   => :get,
                              :'job-id' => job_id,
                              :key      => self.auth_key }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining logs XML" if html_result.nil?

        # parse the XML data
        data          = Nokogiri::XML(html_result)
        response_code = data.xpath('//response/@status').to_s

        if response_code == "success"
          # check if the job is finished
          job_response_code = data.xpath('//response/result/job/status')[0].content.to_s

          if job_response_code == "FIN"
            data.xpath('//response/result/log/logs/*').each do |log_xml|
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
    end
  end
end
