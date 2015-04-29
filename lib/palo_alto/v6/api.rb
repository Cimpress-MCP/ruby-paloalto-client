require "palo_alto/v6/device_api"
require "palo_alto/v6/virtual_system_api"
require "palo_alto/v6/address_api"
require "palo_alto/v6/address_group_api"
require "palo_alto/v6/log_api"

module PaloAlto
  module V6
    class Api < Common::BaseApi
      # include required APIs for functionality
      include PaloAlto::V6::DeviceApi
      include PaloAlto::V6::VirtualSystemApi
      include PaloAlto::V6::AddressApi
      include PaloAlto::V6::AddressGroupApi
      include PaloAlto::V6::LogApi
    end
  end
end
