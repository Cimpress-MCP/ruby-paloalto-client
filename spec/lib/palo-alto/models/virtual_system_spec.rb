require "palo-alto/models/virtual-system"

describe "PaloAlto::Models::VirtualSystem" do
  let(:name) { "vsys-1" }

  before do
    @virtual_system = PaloAlto::Models::VirtualSystem.new(name: name)
  end

  it "has a name attribute" do
    expect(@virtual_system).to respond_to(:name)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::VirtualSystem instance" do
      expect(@virtual_system).to be_instance_of(PaloAlto::Models::VirtualSystem)
    end

    it "assigns name" do
      expect(@virtual_system.name).to eq(name)
    end
  end
end
