require "palo_alto/v6/virtual_system_api"
require "palo_alto/helpers/rest"
require "nokogiri"

describe "PaloAlto::V6::VirtualSystemApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::VirtualSystemApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".virtual_systems" do
    let(:virtual_system_xml)                                 { File.open(fixture_file("virtual_systems.xml")).read }
    let(:blank_virtual_system_xml)                           { File.open(fixture_file("blank_virtual_systems.xml")).read }
    let(:no_rulebase_virtual_system_xml)                     { File.open(fixture_file("no_rulebase_virtual_systems.xml")).read }
    let(:no_address_virtual_system_xml)                      { File.open(fixture_file("no_address_virtual_systems.xml")).read }
    let(:no_address_group_virtual_system_xml)                { File.open(fixture_file("no_address_group_virtual_systems.xml")).read }
    let(:blank_address_group_description_virtual_system_xml) { File.open(fixture_file("address_group_missing_description.xml")).read }

    describe "when virtual systems exist" do
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(virtual_system_xml)
        @virtual_systems = DummyClass.virtual_systems

        expect(@virtual_systems).to be_instance_of(Array)
      end

      it "returns an array of addresses, address_groups and virtual_systems" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(virtual_system_xml)
        @virtual_systems = DummyClass.virtual_systems

        expect(@virtual_systems[0].addresses).to_not be_empty
        expect(@virtual_systems[0].address_groups).to_not be_empty
        expect(@virtual_systems[0].rulebases).to_not be_empty
      end

      it "returns an empty array for addresses when none exist" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(no_address_virtual_system_xml)
        @virtual_systems = DummyClass.virtual_systems
        expect(@virtual_systems[0].addresses).to be_empty
      end

      it "returns an empty array for address_groups when none exist" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(no_address_group_virtual_system_xml)
        @virtual_systems = DummyClass.virtual_systems
        expect(@virtual_systems[0].address_groups).to be_empty
      end

      it "returns an empty array for rulebases when none exist" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(no_rulebase_virtual_system_xml)
        @virtual_systems = DummyClass.virtual_systems
        expect(@virtual_systems[0].rulebases).to be_empty
      end

      describe "address group addresses" do
        it "associates addresses with the corresponding address group" do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(virtual_system_xml)
          @virtual_systems = DummyClass.virtual_systems

          expect(@virtual_systems[0].address_groups[0].addresses).to_not be_empty
        end

        it "assigns a blank 'description' when the address group has no description" do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_address_group_description_virtual_system_xml)
          @virtual_systems = DummyClass.virtual_systems

          expect(@virtual_systems[0].address_groups[0].description).to eq("")
        end
      end
    end

    describe "when no virtual systems exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_virtual_system_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.virtual_systems).to eq([])
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.virtual_systems }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.virtual_systems }.to raise_exception
      end
    end
  end
end
