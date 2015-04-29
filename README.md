# Ruby::PaloAlto::Client

Ruby client to interact with the PaloAlto Firewall and Panamera service
for Version 6.X of the API.

## Background

The following is a notional JSON-based hierarchical representation of the association within the PaloAlto configuration:

```bash
Device has_many: VirtualSystem

VirtualSystem has_many:
  - Address
  - AddressGroup
  - Ruleset

AddressGroup has_many: Addresses
```

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
Note that queries against the PaloAlto target are performed once for each of the association methods:

- .devices
- .virtual_systems
- .address_groups
- .addresses

### Devices

To obtain a list of all devices, perform the following:

```bash
# query device directly
pa_client.devices

=> [#<PaloAlto::Models::Device:0x000000021b1550 @name="localhost.localdomain", @ip="127.0.0.1", @virtual_systems=[#<PaloAlto::Models::VirtualSystem:0x000000021b0b00 @name="vsys1", @addresses=[], @address_groups=[], @rulebases=[]>]>]

# query device once, parse data in-memory
devices = pa_client.devices

device = devices[0]
device.virtual_systems

vsys = device.virtual_systems[0]
vsys.addresses
vsys.address_groups
vsys.rulesets
```

### Virtual Systems

To obtain a list of all virtual systems, perform the following:

```bash
# query device directly
pa_client.virtual_systems

=> [#<PaloAlto::Models::VirtualSystem:0x000000027319f8 @name="vsys1", @addresses=[#<PaloAlto::Models::Address:0x0000000272bc60 @name="pool-range", @ip="192.168.80.0/24">, #<PaloAlto::Models::Address:0x0000000272b260 @name="some-ip", @ip="2.2.2.2">], @address_groups=[#<PaloAlto::Models::AddressGroup:0x0000000272a3b0 @name="test", @description="Testing using API", @addresses=[#<PaloAlto::Models::Address:0x00000002729c08 @name="some-ip", @ip="2.2.2.2">]>], @rulebases=[#<PaloAlto::Models::Rulebase:0x00000002729208 @name="DNS">, #<PaloAlto::Models::Rulebase:0x00000002728a88 @name="Allow same network">, #<PaloAlto::Models::Rulebase:0x00000002722138 @name="Deny All">]>]

# query device once, parse data in-memory:
vsystems = pa_client.virtual_systems

vsys = vsystems[0]
vsys.addresses
vsys.address_groups

address_group = vsys.address_groups[0]
address_group.addresses
vsys.rulesets
```

### Addresses

To obtain a list of all addresses, perform the following:

```bash
# query device directly
pa_client.addresses

=> [#<PaloAlto::Models::Address:0x0000000268f158 @name="pool-range", @ip="192.168.80.0/24">, #<PaloAlto::Models::Address:0x0000000268e528 @name="some-ip", @ip="2.2.2.2">]

# query device once, parse data in-memory
addresses = pa_client.addresses

address = addresses[0]
```

### Address Groups

To obtain a list of all address groups, perform the following:

```bash
# query device directly
pa_client.address_groups

=> [#<PaloAlto::Models::AddressGroup:0x00000002661870 @name="test", @description="Testing using API", @addresses=[#<PaloAlto::Models::Address:0x00000002660f88 @name="", @ip="2.2.2.2">]>]

# query device once, parse data in-memory
address_groups = pa_client.address_groups

address_group = address_groups[0]
```

### Logs

The logs interface allows capturing logs from the PaloAlto device. This process is an asynchronous task and requires
triggering a job on the PaloAlto device to generate the logs, and then fetching the logs from the device when the
job has been completed. If the log job has not yet completed, an Exception is raised indicating that the Job
has not yet completed and the logs are not yet available.

#### Traffic Logs

To capture traffic logs from the PaloAlto device, perform the following:

```bash
# create log generation job and capture the job_id
log_job_id = pa_client.generate_logs(log_type: "traffic")

# query for the logs - job has not yet completed, Exception is raised
pa_client.get_logs(job_id: log_job_id)

=> Exception: "Log job with ID '12345' is still in progress"

# query for the logs - job has completed, log array is returned
pa_client.get_logs(job_id: log_job_id)

=> [#<PaloAlto::Models::TrafficLogEntry:0x0000000295ec30 @id="6143315061768195499", @serial="001606017466", @seqno="3936876", @type="TRAFFIC", @domain="1", @receive_time="2015/04/30 08:44:51", @actionflags="0x0", @subtype="end", @config_ver="1", @time_generated="2015/04/30 08:44:51", @src="192.168.5.156", @dst="192.168.4.3", @rule="allow global-protect-ssl", @srcloc="CN", @dstloc="US", @app="insufficient-data", @vsys="vsys1", @from="outside", @to="outside", @inbound_if="ethernet1/3", @outbound_if="ethernet1/3", @time_received="2015/04/30 08:44:51", @sessionid="3396", @repeatcnt="1", @sport="60000", @dport="5632", @natsport="0", @natdport="0", @flags="0", @flag_pcap="no", @flag_flagged="no", @flag_proxy="no", @flag_url_denied="no", @flag_nat="no", @captive_portal="no", @exported="no", @transaction="no", @pbf_c2s="no", @pbf_s2c="no", @temporary_match="no", @sym_return="no", @decrypt_mirror="no", @proto="udp", @action="allow", @cpadding="0", @bytes="60", @bytes_sent="60", @bytes_received="0", @packets="1", @start="2015/04/30 08:43:51", @elapsed="0", @category="any", @padding="0", @pkts_sent="1", @pkts_received="0">]
```
