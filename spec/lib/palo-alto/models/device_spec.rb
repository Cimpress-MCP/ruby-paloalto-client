require "palo-alto/models/device"

describe "PaloAlto::Models::Device" do
  let(:name) { "test-device" }
  let(:ip)   { "2.2.2.2" }

  before do
    @device = PaloAlto::Models::Device.new(name: name,
                                           ip:   ip)
  end

  it "has a name attribute" do
    expect(@device).to respond_to(:name)
  end

  it "has an ip attribute" do
    expect(@device).to respond_to(:ip)
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
  end
end
