require "palo-alto/v6/device-api"
require "palo-alto/v6/virtual-system-api"
require "palo-alto/v6/address-api"
require "palo-alto/v6/address-group-api"

module PaloAlto
  module V6
    class Api < Common::BaseApi
      # include required APIs for functionality
      include PaloAlto::V6::DeviceApi
      include PaloAlto::V6::VirtualSystemApi
      include PaloAlto::V6::AddressApi
      include PaloAlto::V6::AddressGroupApi
    end
  end
end
