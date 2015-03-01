require "nokogiri"

module PaloAlto
  class BaseApi
    attr_accessor :host, :port, :ssl, :username, :password, :auth_key

    # Create and returns a new PaloAlto::V6::Api instance with the given parameters
    #
    # == Attributes
    #
    # * +host+        - Host where the PaloAlto device is located
    # * +port+        - Port on which the PaloAlto API service is listening
    # * +ssl+         - (Boolean) Whether the API interaction is over SSL
    # * +username+    - Username used to authenticate against the API
    # * +password+    - Password used to authenticate against the API
    #
    # == Example
    #
    #  PaloAlto::V6::Api.new host:        'localhost.localdomain',
    #                        port:        '443',
    #                        ssl:         true,
    #                        username:    'test_user',
    #                        password:    'test_pass'
    def initialize(host:, port:, ssl: false, username:, password:)
      self.host     = host
      self.port     = port
      self.ssl      = ssl
      self.username = username
      self.password = password

      # attempt to obtain the auth_key
      raise "Exception attempting to obtain the auth_key" if (self.auth_key = get_auth_key).nil?

      self
    end

    # Construct and return the API endpoint
    def endpoint
      "http#{('s' if self.ssl)}://#{self.host}:#{self.port}/api/"
    end

    private

    # Perform a query to the API endpoint for an auth_key based on the credentials provided
    def get_auth_key
      auth_key = nil

      # establish the required options for the key request
      options            = {}
      options[:url]      = self.endpoint
      options[:method]   = :post
      options[:payload]  = { "type"     => "keygen",
                             "user"     => self.username,
                             "password" => self.password }

      # get and parse the response for the key
      http_response = PaloAlto::Helpers::Rest.make_request(options)
      unless http_response.nil?
        xml_data = Nokogiri::XML(http_response)
        if xml_data.xpath('//response/@status').to_s == "success"
          return xml_data.xpath('//response/result/key')[0].content
        else
          return nil
        end
      end

      auth_key
    end
  end
end
