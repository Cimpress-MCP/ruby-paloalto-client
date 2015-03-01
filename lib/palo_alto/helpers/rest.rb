require "rest_client"

module PaloAlto
  module Helpers
    class Rest
      # Perform an HTTP request with the respective options
      #
      # == Attributes
      #
      # * +opts+ - Hash of options to include in the request
      #
      # == Input Hash
      #
      # The input hash should contain at a minimum, the following:
      #
      # * +url+     - The URL to send the request to
      # * +method+  - The HTTP method to execute (:get, :post, etc)
      # * +payload+ - Hash of key/value pairs (parameters) to send with the request
      #
      # == Returns
      #
      # Response of the HTML request
      def self.make_request(opts)
        options                           = {}
        options[:verify_ssl]              = OpenSSL::SSL::VERIFY_NONE
        options[:headers]                 = {}
        options[:headers]["User-Agent"]   = "ruby-keystone-client"
        options[:headers]["Accept"]       = "application/xml"
        options[:headers]["Content-Type"] = "application/xml"

        # merge in settings from method caller
        options = options.merge(opts)

        # provide a block to ensure the response is parseable rather than
        # having RestClient throw an exception
        RestClient::Request.execute(options) do |response, request, result|
          if response and response.code == 200
            return response.body
          else
            return nil
          end
        end
      end
    end
  end
end
