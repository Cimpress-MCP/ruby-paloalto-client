module PaloAlto
  module V6
    module LogApi
      LOG_TYPES = [ "traffic", "threat",   "config",
                    "system",  "hipmatch", "wildfire",
                    "url",     "data" ]

      # Kicks off a job to generate logs asynchronously
      #
      # == Parameters
      #
      #  * +log_type+ - Type of log to generate
      #
      # == Returns
      #
      #  * +String+ - String containing the Job ID
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful or an
      #                  invalid log_type parameter is passed
      def generate_logs(log_type:)
        raise "Invalid log_type - must be one of #{LOG_TYPES}" unless LOG_TYPES.include?(log_type)

        log_job_id = ''

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type       => "log",
                              :'log-type' => log_type,
                              :key        => self.auth_key }

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
    end
  end
end
