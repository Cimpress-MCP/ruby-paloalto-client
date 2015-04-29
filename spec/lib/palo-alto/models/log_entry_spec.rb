require "nokogiri"
require "palo_alto/models/log_entry"

describe "PaloAlto::Models::LogEntry" do
  let(:traffic_log_xmlfile)  { File.open(fixture_file("traffic_logs.xml")).read }
  let(:traffic_log_nokogiri) { Nokogiri::XML(traffic_log_xmlfile) }
  let(:traffic_log_xml)      { traffic_log_nokogiri.xpath('//response/result/log/logs/*')[0] }

  describe ".initialize" do
    it "returns a PaloAlto::Models::LogEntry instance" do
      @log = PaloAlto::Models::LogEntry.new(id: '129047', :serial => '001606017466', :seqno => '3926388', :type => 'TRAFFIC')
      expect(@log).to be_instance_of(PaloAlto::Models::LogEntry)
    end

    it "initializes setters and getters for the specified log type" do
      @log = PaloAlto::Models::LogEntry.new(id: '129047', :serial => '001606017466', :seqno => '3926388', :type => 'TRAFFIC', addl_attrs: [ 'attr1', 'attr2' ])

      expect(@log).to respond_to(:attr1)
      expect(@log).to respond_to(:attr2)
    end
  end

  describe ".from_xml" do
    describe "for missing log types" do
      let(:missing_type_log_xmlfile)  { File.open(fixture_file("missing_type_logs.xml")).read }
      let(:missing_type_log_nokogiri) { Nokogiri::XML(missing_type_log_xmlfile) }
      let(:missing_type_log_xml)      { missing_type_log_nokogiri.xpath('//response/result/log/logs/*')[0] }

      it "raises an Exception" do
        expect{ PaloAlto::Models::LogEntry.from_xml(xml_data: missing_type_log_xml) }.to raise_exception
      end
    end

    describe "for unsupported log types" do
      let(:unsupported_log_xmlfile)  { File.open(fixture_file("unsupported_logs.xml")).read }
      let(:unsupported_log_nokogiri) { Nokogiri::XML(unsupported_log_xmlfile) }
      let(:unsupported_log_xml)      { unsupported_log_nokogiri.xpath('//response/result/log/logs/*')[0] }

      it "raises an Exception" do
        expect{ PaloAlto::Models::LogEntry.from_xml(xml_data: unsupported_log_xml) }.to raise_exception
      end
    end

    describe "for unsupported attributes" do
      let(:unsupported_log_attribute_xmlfile)  { File.open(fixture_file("unsupported_log_attribute.xml")).read }
      let(:unsupported_log_attribute_nokogiri) { Nokogiri::XML(unsupported_log_attribute_xmlfile) }
      let(:unsupported_log_attribute_xml)      { unsupported_log_attribute_nokogiri.xpath('//response/result/log/logs/*')[0] }

      it "raises an Exception" do
        expect{ PaloAlto::Models::LogEntry.from_xml(xml_data: unsupported_log_attribute_xml) }.to raise_exception
      end
    end

    describe "for supported log types" do
      describe "for traffic logs" do
        let(:traffic_log_xmlfile)  { File.open(fixture_file("traffic_logs.xml")).read }
        let(:traffic_log_nokogiri) { Nokogiri::XML(traffic_log_xmlfile) }
        let(:traffic_log_xml)      { traffic_log_nokogiri.xpath('//response/result/log/logs/*')[0] }

        it "returns a PaloAlto::Models::TrafficLogEntry instance" do
          expect(PaloAlto::Models::LogEntry.from_xml(xml_data: traffic_log_xml)).to be_instance_of(PaloAlto::Models::TrafficLogEntry)
        end
      end
    end
  end
end
