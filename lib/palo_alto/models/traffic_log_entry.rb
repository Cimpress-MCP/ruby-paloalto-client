require "palo_alto/models/log_entry"

module PaloAlto
  module Models
    class TrafficLogEntry < PaloAlto::Models::LogEntry
      attr_accessor :domain, :receive_time, :actionflags, :subtype, :config_ver, :time_generated, :src, :dst,
                    :rule, :srcloc, :dstloc, :app, :vsys, :from, :to, :inbound_if, :outbound_if, :time_received,
                    :sessionid, :repeatcnt, :sport, :dport, :natsport, :natdport, :flags, :flag_pcap, :flag_flagged,
                    :flag_proxy, :flag_url_denied, :flag_nat, :captive_portal, :exported, :transaction, :pbf_c2s,
                    :pbf_s2c, :temporary_match, :sym_return, :decrypt_mirror, :proto, :action, :cpadding, :bytes,
                    :bytes_sent, :bytes_received, :packets, :start, :elapsed, :category, :padding, :pkts_sent, :pkts_received

      # Create and returns a new PaloAlto::Models::LogEntry instance with the given parameters
      #
      # == Attributes
      #
      # * +log_id+ - Unique ID of the log
      # * +serial+ - Serial number of the log
      # * +seqno+  - Sequence number of the log
      #
      # == Example
      #
      #  PaloAlto::Models::TrafficLogEntry.new log_id: '23954702',
      #                                        serial: '9390235701',
      #                                        seqno:  '2'
      def initialize(log_id:, serial:, seqno:)
        super(log_id: log_id, serial: serial, seqno: seqno, type: 'TRAFFIC')

        self
      end
    end
  end
end
