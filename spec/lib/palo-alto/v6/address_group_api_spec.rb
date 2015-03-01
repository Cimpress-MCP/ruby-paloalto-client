require "palo-alto/v6/address-group-api"
require "palo-alto/helpers/rest"

describe "PaloAlto::V6::AddressGroupApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::AddressGroupApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".address_groups" do
    let(:address_group_xml)           { File.open(fixture_file("address_groups.xml")).read }
    let(:blank_address_group_xml)     { File.open(fixture_file("blank_address_groups.xml")).read }
    let(:no_member_address_group_xml) { File.open(fixture_file("no_members_address_groups.xml")).read }

    describe "when address groups exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(address_group_xml)
      end

      before do
        @address_groups = DummyClass.address_groups
      end

      it "parses the XML response into the required format" do
        expect(@address_groups).to be_instance_of(Array)
      end
    end

    describe "when no address groups exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_address_group_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.address_groups).to eq([])
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.address_groups }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.address_groups }.to raise_exception
      end
    end
  end
end
