require "crack/xml"

module PaloAlto
  module V6
    module JobApi
      # Get information about a particular operational
      #
      # == Parameters
      #
      #  * +job_id+ - ID of the job to query for
      #
      # == Returns
      #
      #  * +JSON+ - JSON data containing the job ID and corresponding status
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def operational_job(job_id:)
        job_json = { id: job_id }

        # configure options for the request
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { :type       => "op",
                              :cmd        => "<show><jobs><id>#{job_id}</id></jobs></show>",
                              :key        => self.auth_key }

        html_result = Helpers::Rest.make_request(options)

        raise "Error obtaining log job XML" if html_result.nil?

        return Crack::XML.parse(html_result)
      end
    end
  end
end
