require "palo_alto/v6/address_group_api"
require "palo_alto/helpers/rest"
require "palo_alto/models/address"
require "palo_alto/models/address_group"
require "nokogiri"

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
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(address_group_xml)
        @address_groups = DummyClass.address_groups

        expect(@address_groups).to be_instance_of(Array)
      end

      describe "for groups that contain members" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(address_group_xml)
          @address_groups = DummyClass.address_groups
        end

        it "returns a list of addresses" do
          expect(@address_groups[0].addresses).to_not be_empty
        end
      end

      describe "for groups that have no members" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(no_member_address_group_xml)
          @address_groups = DummyClass.address_groups
        end

        it "returns an empty array" do
          expect(@address_groups[0].addresses).to be_empty
        end
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
