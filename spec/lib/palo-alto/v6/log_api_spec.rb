require "palo_alto/v6/log_api"
require "palo_alto/helpers/rest"

describe "PaloAlto::V6::LogApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::LogApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".generate_logs" do
    let(:log_success_xml) { File.open(fixture_file("log_job.xml")).read }

    describe "when specifying an invalid log_type parameter" do
      it "raises an exception" do
        expect{ DummyClass.generate_logs(log_type: "blah") }.to raise_exception
      end
    end

    describe "for invalid number of logs specified" do
      it "raises an exception when number of logs is less than minimum" do
        expect{ DummyClass.generate_logs(log_type: "traffic", num_logs: -1000) }.to raise_exception
      end

      it "raises an exception when number of logs is greater than maximum" do
        expect{ DummyClass.generate_logs(log_type: "traffic", num_logs: 99999) }.to raise_exception
      end
    end

    describe "when the job is kicked off successfully" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_success_xml)
      end

      it "returns the job_id for the log job" do
        expect(DummyClass.generate_logs(log_type: "traffic")).to eq("2014")
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.generate_logs(log_type: "traffic") }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.generate_logs(log_type: "traffic") }.to raise_exception
      end
    end
  end

  describe ".log_job_complete?" do
    let(:job_id)              { "2015" }
    let(:log_in_progress_xml) { File.open(fixture_file("log_in_progress.xml")).read }
    let(:log_complete_xml)    { File.open(fixture_file("log_complete.xml")).read }

    describe "when a job is still in progress" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_in_progress_xml)
      end

      it "returns false" do
        expect(DummyClass.log_job_complete?(job_id: job_id)).to eq(false)
      end
    end

    describe "when a job has completed" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_complete_xml)
      end

      it "returns true" do
        expect(DummyClass.log_job_complete?(job_id: job_id)).to eq(true)
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.log_job_complete?(job_id: job_id) }.to raise_exception
      end

      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.log_job_complete?(job_id: job_id) }.to raise_exception
      end
    end
  end

  describe ".get_logs" do
    let(:job_id)          { "2014" }
    let(:log_xml)         { File.open(fixture_file("traffic_logs.xml")).read }
    let(:blank_log_xml)   { File.open(fixture_file("blank_traffic_logs.xml")).read }
    let(:pending_log_xml) { File.open(fixture_file("pending_traffic_logs.xml")).read }

    describe "when logs exist" do
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_xml)
        logs = DummyClass.get_logs(job_id: job_id)

        expect(logs).to be_instance_of(Array)
        expect(logs).to_not be_empty
      end
    end

    describe "when no logs exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_log_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.get_logs(job_id: job_id)).to eq([])
      end
    end

    describe "when the log job is not complete" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(pending_log_xml)
      end

      it "raises an Exception" do
        expect{ DummyClass.get_logs(job_id: job_id) }.to raise_exception
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.get_logs(job_id: job_id) }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.get_logs(job_id: job_id) }.to raise_exception
      end
    end
  end

  describe "private functions" do
    describe "get_log_xml" do
      let(:job_id)          { "2014" }
      let(:log_xml)         { File.open(fixture_file("traffic_logs.xml")).read }
      let(:invalid_log_xml) { File.open(fixture_file("invalid_format.xml")).read }

      describe "for valid XML data" do
        it "parses the XML response into the required format" do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_xml)
          logs = DummyClass.send(:get_log_xml, { job_id: job_id })

          expect(logs).to be_instance_of(Nokogiri::XML::Document)
        end
      end

      describe "for nil response from PaloAlto service" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(nil)
        end

        it "raises an Exception" do
          expect{ DummyClass.send(:get_log_xml, { job_id: job_id }) }.to raise_exception
        end
      end

      describe "for invalid XML data" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_xml)
          expect(Nokogiri::XML::Document).to receive(:parse).and_raise(Exception)
        end

        it "raises an Exception" do
          expect{ DummyClass.send(:get_log_xml, { job_id: job_id }) }.to raise_exception
        end
      end
    end

    describe "get_log_xml_response_code" do
      let(:log_xml)  { File.open(fixture_file("traffic_logs.xml")).read }
      let(:xml_data) { Nokogiri::XML(log_xml) }

      describe "for a valid Nokogiri::XML::Document" do
        it "returns the response code" do
          expect(DummyClass.send(:get_log_xml_response_code, { xml_data: xml_data })).to eq("success")
        end
      end

      describe "for an input type that is not a Nokogiri::XML::Document" do
        it "raises an Exception" do
          expect{ DummyClass.send(:get_log_xml_response_code, { xml_data: "test" }) }.to raise_exception
        end
      end
    end

    describe "get_log_job_status" do
      let(:log_xml)  { File.open(fixture_file("traffic_logs.xml")).read }
      let(:xml_data) { Nokogiri::XML(log_xml) }

      describe "for a valid Nokogiri::XML::Document" do
        it "returns the response code" do
          expect(DummyClass.send(:get_log_job_status, { xml_data: xml_data })).to eq("FIN")
        end
      end

      describe "for an input type that is not a Nokogiri::XML::Document" do
        it "raises an Exception" do
          expect{ DummyClass.send(:get_log_job_status, { xml_data: "test" }) }.to raise_exception
        end
      end
    end
  end
end
