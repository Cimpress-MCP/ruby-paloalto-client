require "palo-alto/models/address-group"

describe "PaloAlto::Models::AddressGroup" do
  let(:name)        { "test-address-group" }
  let(:description) { "test-address-group-description" }

  before do
    @address_group = PaloAlto::Models::AddressGroup.new(name: name, description: description)
  end

  it "has a name attribute" do
    expect(@address_group).to respond_to(:name)
  end

  it "has a description attribute" do
    expect(@address_group).to respond_to(:description)
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
  end
end
