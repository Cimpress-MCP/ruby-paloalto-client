# Ruby::Paloalto::Client

Ruby client to interact with the PaloAlto Firewall and Panamera service
for Version 6.X of the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-paloalto-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-paloalto-client

## Usage

### Initialization

To interface with a PaloAlto API endpoint, start by requiring the PaloAlto library:

```bash
require 'palo-alto/client'

=> true
```

Then, establish a connection to the PaloAlto API with which you wish to interact. For example, this
PaloAlto device is running version 6 of the API and is located at 'localhost' running on port 443 (secure), and we are connecting with the following:

- Host:        localhost
- Port:        443
- Username:    admin
- Password     adminpass
- SSL:         true
- API Version: 6

```bash
pa_client = PaloAlto::Client.new host:        "localhost",
                                 port:        "443",
                                 username:    "admin",
                                 password:    "adminpass",
                                 ssl:         true,
                                 api_version: "6"

=> #<PaloAlto::V6::Api:0x000000026d7340 @host="localhost", @port="443", @ssl=true, @username="admin", @password="adminpass", @auth_key="LUFRPT0va1dzTWZCWjhReWkx354gsUJ0T1VyeFBVRlE9cVpGWUEzNmFmeWtTQU1GcmNHVE0zeHdWRHJKUlhJYXBUMWlXdFBLVnhqND0=">
```

Once you have your client "pa_client", you can continue to retrieve and manipulate data within the PaloAlto target device.

### Addresses

To obtain a list of all addresses, perform the following:

```bash
pa_client.addresses

=> [#<PaloAlto::Models::Address:0x0000000268f158 @name="pool-range", @ip="192.168.80.0/24">, #<PaloAlto::Models::Address:0x0000000268e528 @name="some-ip", @ip="2.2.2.2">]
```

### Address Groups

To obtain a list of all address groups, perform the following (note that address groups contain addresses):

```bash
pa_client.address_groups

=> [#<PaloAlto::Models::AddressGroup:0x00000002661870 @name="test", @description="Testing using API", @addresses=[#<PaloAlto::Models::Address:0x00000002660f88 @name="", @ip="2.2.2.2">]>]

pa_client.address_groups[0].addresses

=> [#<PaloAlto::Models::Address:0x000000033ea708 @name="some-ip", @ip="">]
```
