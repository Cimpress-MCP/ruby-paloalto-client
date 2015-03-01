require "palo-alto/models/device"

describe "PaloAlto::Models::Device" do
  let(:name)            { "test-device" }
  let(:ip)              { "2.2.2.2" }
  let(:virtual_systems) { [ "a", "b" ] }

  before do
    @device = PaloAlto::Models::Device.new(name:            name,
                                           ip:              ip,
                                           virtual_systems: virtual_systems)
  end

  it "has a name attribute" do
    expect(@device).to respond_to(:name)
  end

  it "has an ip attribute" do
    expect(@device).to respond_to(:ip)
  end

  it "has a virtual_systems attribute" do
    expect(@device).to respond_to(:virtual_systems)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Device instance" do
      expect(@device).to be_instance_of(PaloAlto::Models::Device)
    end

    it "assigns name" do
      expect(@device.name).to eq(name)
    end

    it "assigns ip" do
      expect(@device.ip).to eq(ip)
    end

    it "assigns virtual_systems" do
      expect(@device.virtual_systems).to eq(virtual_systems)
    end
  end
end
