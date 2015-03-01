require "palo-alto/client/version"
require "palo-alto/common/base-api"
require "palo-alto/helpers/rest"

module PaloAlto
  module Client
    class << self
      attr_accessor :host, :port, :ssl, :username, :password, :api_version

      # Create and returns a new PaloAlto::VX::Api instance with the given parameters
      #
      # == Attributes
      #
      # * +host+        - Host where the PaloAlto device is located
      # * +port+        - Port on which the PaloAlto API service is listening
      # * +ssl+         - (Boolean) Whether the API interaction is over SSL
      # * +username+    - Username used to authenticate against the API
      # * +password+    - Password used to authenticate against the API
      # * +api_version+ - Major version of the API being interacted with
      #
      # == Example
      #
      #  PaloAlto::Client.new host:        'localhost.localdomain',
      #                       port:        '443',
      #                       ssl:         true,
      #                       username:    'test_user',
      #                       password:    'test_pass',
      #                       api_version: '6'
      def new(host:, port:, ssl: false, username:, password:, api_version:)
        api = nil

        # check that the API version is implemented
        api_version_file = File.join(File.dirname(__FILE__), "v#{api_version}", "api.rb")
        if File.exist?(api_version_file)
          require api_version_file.sub('.rb', '')

          api = Object.const_get("PaloAlto::V#{api_version}::Api").new(host: host,
                                                                       port: port,
                                                                       ssl:  ssl,
                                                                       username: username,
                                                                       password: password)
        else
          raise "API version '#{api_version}' is not implemented"
        end

        api
      end
    end
  end
end
