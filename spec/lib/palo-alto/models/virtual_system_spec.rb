require "palo-alto/models/virtual-system"

describe "PaloAlto::Models::VirtualSystem" do
  let(:name)           { "vsys-1" }
  let(:addresses)      { [ "a", "b" ] }
  let(:address_groups) { [ "c", "d" ] }
  let(:rulebases)      { [ "e", "f" ] }

  before do
    @virtual_system = PaloAlto::Models::VirtualSystem.new(name:           name,
                                                          addresses:      addresses,
                                                          address_groups: address_groups,
                                                          rulebases:      rulebases)
  end

  it "has a name attribute" do
    expect(@virtual_system).to respond_to(:name)
  end

  it "has an addresses attribute" do
    expect(@virtual_system).to respond_to(:addresses)
  end

  it "has an address_groups attribute" do
    expect(@virtual_system).to respond_to(:address_groups)
  end

  it "has a rulebases attribute" do
    expect(@virtual_system).to respond_to(:rulebases)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::VirtualSystem instance" do
      expect(@virtual_system).to be_instance_of(PaloAlto::Models::VirtualSystem)
    end

    it "assigns name" do
      expect(@virtual_system.name).to eq(name)
    end

    it "assigns addresses" do
      expect(@virtual_system.addresses).to eq(addresses)
    end

    it "assigns address_groups" do
      expect(@virtual_system.address_groups).to eq(address_groups)
    end

    it "assigns rulebases" do
      expect(@virtual_system.rulebases).to eq(rulebases)
    end
  end
end
