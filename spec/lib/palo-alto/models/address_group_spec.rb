require "palo_alto/models/address_group"

describe "PaloAlto::Models::AddressGroup" do
  let(:name)        { "test-address-group" }
  let(:description) { "test-address-group-description" }
  let(:addresses)   { [ "a", "b" ] }

  before do
    @address_group = PaloAlto::Models::AddressGroup.new(name:        name,
                                                        description: description,
                                                        addresses:   addresses)
  end

  it "has a name attribute" do
    expect(@address_group).to respond_to(:name)
  end

  it "has a description attribute" do
    expect(@address_group).to respond_to(:description)
  end

  it "has an addresses attribute" do
    expect(@address_group).to respond_to(:addresses)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::AddressGroup instance" do
      expect(@address_group).to be_instance_of(PaloAlto::Models::AddressGroup)
    end

    it "assigns name" do
      expect(@address_group.name).to eq(name)
    end

    it "assigns description" do
      expect(@address_group.description).to eq(description)
    end

    it "assigns addresses" do
      expect(@address_group.addresses).to eq(addresses)
    end
  end
end
