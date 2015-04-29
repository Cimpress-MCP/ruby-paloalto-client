require "palo_alto/models/log_entry"

module PaloAlto
  module Models
    class SystemLogEntry < PaloAlto::Models::LogEntry
      attr_accessor :domain, :receive_time, :actionflags, :subtype, :config_ver, :time_generated,
                    :eventid, :fmt, :id, :module, :severity, :opaque

      # Create and returns a new PaloAlto::Models::LogEntry instance with the given parameters
      #
      # == Attributes
      #
      # * +log_id+ - ID of the log
      # * +serial+ - Serial number of the log
      # * +seqno+  - Sequence number of the log
      #
      # == Example
      #
      #  PaloAlto::Models::SystemLogEntry.new log_id: '23954702',
      #                                       serial: '9390235701',
      #                                       seqno:  '2'
      def initialize(log_id:, serial:, seqno:)
        super(log_id: log_id, serial: serial, seqno: seqno, type: 'SYSTEM')

        self
      end
    end
  end
end
