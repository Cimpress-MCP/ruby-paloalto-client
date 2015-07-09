require "palo_alto/v6/zone_api"
require "palo_alto/helpers/rest"

describe "PaloAlto::V6::ZoneApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::ZoneApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".zones" do
    let(:zone_xml)       { File.open(fixture_file("zones.xml")).read }
    let(:blank_zone_xml) { File.open(fixture_file("blank_zones.xml")).read }

    describe "when zones exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(zone_xml)
      end

      it "parses the XML response into the required format" do
        expect(DummyClass.zones).to be_instance_of(Array)
      end
    end

    describe "when no zones exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_zone_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.zones).to eq([])
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.zones }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.zones }.to raise_exception
      end
    end
  end
end
