require "palo_alto/v6/address_api"
require "palo_alto/helpers/rest"

describe "PaloAlto::V6::AddressApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::AddressApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".addresses" do
    let(:address_xml)       { File.open(fixture_file("addresses.xml")).read }
    let(:blank_address_xml) { File.open(fixture_file("blank_addresses.xml")).read }

    describe "when addresses exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(address_xml)
      end

      it "parses the XML response into the required format" do
        expect(DummyClass.addresses).to be_instance_of(Array)
      end
    end

    describe "when no addresses exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_address_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.addresses).to eq([])
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.addresses }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.addresses }.to raise_exception
      end
    end
  end
end
