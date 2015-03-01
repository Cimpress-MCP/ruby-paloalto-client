require "palo-alto/v6/address-api"

module PaloAlto
  module V6
    class Api < Common::BaseApi
      # include required APIs for functionality
      include PaloAlto::V6::AddressApi
    end
  end
end
