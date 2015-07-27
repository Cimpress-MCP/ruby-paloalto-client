require "palo_alto/v6/job_api"
require "palo_alto/helpers/rest"
require "nokogiri"

describe "PaloAlto::V6::JobApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::JobApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".job(id)" do
    let(:job_id)            { "4" }
    let(:job_xml)           { File.open(fixture_file("job.xml")).read }
    let(:job_not_found_xml) { File.open(fixture_file("job_not_found.xml")).read }

    describe "when the job exists" do
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(job_xml)
        job_info = DummyClass.operational_job(job_id: job_id)

        expect(job_info["response"]["result"]["job"]["status"]).to eq("FIN")
      end
    end

    describe "when the job does not exist" do
      it "returns XML indicating no job exists" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(job_not_found_xml)
        job_info = DummyClass.operational_job(job_id: job_id)

        expect(job_info["response"]["status"]).to eq("error")
        expect(job_info["response"]["msg"]["line"]).to eq("job #{job_id} not found")
      end
    end
  end
end
