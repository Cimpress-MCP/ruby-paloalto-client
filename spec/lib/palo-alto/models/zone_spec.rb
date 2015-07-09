require "palo_alto/models/zone"

describe "PaloAlto::Models::Zone" do
  let(:name) { "ingress" }

  before do
    @zone = PaloAlto::Models::Zone.new(name: name)
  end

  it "has a name attribute" do
    expect(@zone).to respond_to(:name)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Zone instance" do
      expect(@zone).to be_instance_of(PaloAlto::Models::Zone)
    end

    it "assigns name" do
      expect(@zone.name).to eq(name)
    end
  end
end
