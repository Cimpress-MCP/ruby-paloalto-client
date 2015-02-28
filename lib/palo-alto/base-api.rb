module PaloAlto
  class BaseApi
    attr_accessor :host, :port, :ssl, :username, :password

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

      self
    end

    # Construct and return the API endpoint
    def endpoint
      "http#{('s' if self.ssl)}://#{self.host}:#{self.port}/api/"
    end
  end
end
