require "palo-alto/models/address"

describe "PaloAlto::Models::Address" do
  let(:name) { "test-address" }
  let(:ip)   { "2.2.2.2" }

  before do
    @address = PaloAlto::Models::Address.new(name: name, ip: ip)
  end

  it "has a name attribute" do
    expect(@address).to respond_to(:name)
  end

  it "has an ip attribute" do
    expect(@address).to respond_to(:ip)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Address instance" do
      expect(@address).to be_instance_of(PaloAlto::Models::Address)
    end

    it "assigns name" do
      expect(@address.name).to eq(name)
    end

    it "assigns ip" do
      expect(@address.ip).to eq(ip)
    end
  end
end
