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

  describe ".get_logs" do
    let(:job_id)          { "2014" }
    let(:log_xml)         { File.open(fixture_file("traffic_logs.xml")).read }
    let(:blank_log_xml)   { File.open(fixture_file("blank_traffic_logs.xml")).read }
    let(:pending_log_xml) { File.open(fixture_file("pending_traffic_logs.xml")).read }

    describe "when logs exist" do
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(log_xml)
        @logs = DummyClass.get_logs(job_id: job_id)

        expect(@logs).to be_instance_of(Array)
        expect(@logs).to_not be_empty
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

      it "returns an Exception" do
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
end
