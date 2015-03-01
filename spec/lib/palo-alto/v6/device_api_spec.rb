require "palo-alto/v6/device-api"
require "palo-alto/helpers/rest"
require "palo-alto/models/virtual-system"
require "nokogiri"

describe "PaloAlto::V6::DeviceApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::DeviceApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".devices" do
    let(:device_xml)         { File.open(fixture_file("devices.xml")).read }
    let(:blank_device_xml)   { File.open(fixture_file("blank_devices.xml")).read }
    let(:no_vsys_device_xml) { File.open(fixture_file("no_vsys_devices.xml")).read }

    describe "when devices exist" do
      it "parses the XML response into the required format" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(device_xml)
        @devices = DummyClass.devices

        expect(@devices).to be_instance_of(Array)
      end

      describe "for devices that contain virtual_systems" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(device_xml)
          @devices = DummyClass.devices
        end

        it "returns a list of virtual_systems" do
          expect(@devices[0].virtual_systems).to_not be_empty
        end
      end

      describe "for devices that have no virtual_systems" do
        before do
          expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(no_vsys_device_xml)
          @devices = DummyClass.devices
        end

        it "returns an empty array" do
          expect(@devices[0].virtual_systems).to be_empty
        end
      end
    end

    describe "when no devices exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(blank_device_xml)
      end

      it "returns an empty array" do
        expect(DummyClass.devices).to eq([])
      end
    end

    describe "when errors occur" do
      it "raises an exception if an error occurred obtaining XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_raise(Exception)
        expect{ DummyClass.devices }.to raise_exception
      end

      it "raises an exception if an error occurred reported in the XML" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)
        expect{ DummyClass.devices }.to raise_exception
      end
    end
  end
end
