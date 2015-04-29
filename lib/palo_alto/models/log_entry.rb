module PaloAlto
  module Models
    class LogEntry
      attr_accessor :log_id, :serial, :seqno, :type

      SUPPORTED_TYPES = [ "traffic" ]

      # Create and returns a new PaloAlto::Models::LogEntry instance with the given parameters
      #
      # == Attributes
      #
      # * +log_id+    - Unique ID of the log
      # * +serial+    - Serial number of the log
      # * +seqno+     - Sequence number of the log
      # * +type+      - Type of log
      # * +add_attrs+ - Additional attributes to create setters/getters for
      #
      # == Example
      #
      #  PaloAlto::Models::LogEntry.new serial: '9390235701',
      #                                 seqno:  '2',
      #                                 type:   'TRAFFIC'
      def initialize(log_id:, serial:, seqno:, type:, addl_attrs: [])
        self.log_id = log_id
        self.serial = serial
        self.seqno  = seqno
        self.type   = type

        # dynamically create setter/getter methods
        addl_attrs.each do |attr|
          self.instance_eval("def #{attr}; @#{attr}; end")
          self.instance_eval("def #{attr}=(val); @#{attr}=val; end")
        end

        self
      end

      # Construct a log from the incoming Nokogiri XML data type
      #
      # == Attributes
      #
      # * +log_xml+ - Nokogiri element containing the log element
      #
      # == Example
      #
      #  PaloAlto::Models::LogEntry.from_xml xml_data: log_xml
      def self.from_xml(xml_data:)
        log_instance = nil
        log_type     = xml_data.xpath('.//type')[0]

        if log_type.nil? or (log_type_string = log_type.content).nil?
          raise "Log type is unknown"
        else
          # construct the log instance based on supported known log types
          begin
            # get the minimum required attributes for creating any log type
            log_id          = xml_data.xpath('@logid')[0].content
            serial_number   = xml_data.xpath('.//serial')[0].content
            sequence_number = xml_data.xpath('.//seqno')[0].content

            case log_type_string.downcase
            when "traffic"
              log_instance = PaloAlto::Models::TrafficLogEntry.new(log_id: log_id, serial: serial_number, seqno: sequence_number)
            else
              raise "Log type '#{log_type_string}' is unsupported at this time"
            end
          rescue Exception => e
            raise "Could not find a required attribute for the specified log type: #{e.message}"
          end

          begin
            # normalize the attributes and dynamically assign them based on the XML data
            xml_data.xpath('.//*').each do |attr|
              unless [ "log_id", "serial", "seqno", "type" ].include?(attr.name)
                log_instance.send("#{attr.name.gsub('-', '_')}=", attr.content)
              end
            end
          rescue Exception => e
            raise "Unsupported attribute type: #{e.message}"
          end
        end

        return log_instance
      end
    end
  end
end

# load required libraries - required after definition to avoid potential circular dependencies
require "palo_alto/models/traffic_log_entry"
