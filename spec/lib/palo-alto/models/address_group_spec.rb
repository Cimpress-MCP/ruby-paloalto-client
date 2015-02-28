require "palo-alto/models/address-group"

describe "PaloAlto::Models::AddressGroup" do
  let(:name) { "test-address-group" }

  before do
    @address_group = PaloAlto::Models::AddressGroup.new(name: name)
  end

  it "has a name attribute" do
    expect(@address_group).to respond_to(:name)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::AddressGroup instance" do
      expect(@address_group).to be_instance_of(PaloAlto::Models::AddressGroup)
    end

    it "assigns name" do
      expect(@address_group.name).to eq(name)
    end
  end
end
