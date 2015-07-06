require "palo_alto/v6/commit_api"
require "palo_alto/helpers/rest"

describe "PaloAlto::V6::CommitApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::CommitApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  let(:job_id)                 { "77" }
  let(:commit_in_progress_xml) { File.open(fixture_file("commit_in_progress.xml")).read }
  let(:commit_complete_xml)    { File.open(fixture_file("commit_complete.xml")).read }

  describe ".commit_job_complete?" do
    describe "when a job is still in progress" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(commit_in_progress_xml)
      end

      it "returns false" do
        expect(DummyClass.commit_job_complete?(job_id: job_id)).to eq(false)
      end
    end

    describe "when a job has completed" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(commit_complete_xml)
      end

      it "returns true" do
        expect(DummyClass.commit_job_complete?(job_id: job_id)).to eq(true)
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.commit_job_complete?(job_id: job_id) }.to raise_exception
      end
    end
  end

  describe ".commit_job_result" do
    describe "for valid XML" do
      it "returns the resulting Hash of the XML data" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(commit_complete_xml)
        expect(DummyClass.commit_job_result(job_id: job_id)).to be_instance_of(Hash)
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.commit_job_result(job_id: job_id) }.to raise_exception
      end
    end
  end

  describe "private function" do
    describe ".get_job_xml" do
      it "returns a Nokogiri Document for valid XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(commit_complete_xml)
        expect(DummyClass.commit_job_result(job_id: job_id)).to be_instance_of(Hash)
      end

      it "raises an exception when no XML is returned for request" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.send(:commit_job_result, { job_id: job_id }) }.to raise_exception
      end
    end
  end
end
