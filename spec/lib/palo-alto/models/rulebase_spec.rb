require "palo_alto/models/rulebase"

describe "PaloAlto::Models::Rulebase" do
  let(:name) { "test-rulebase" }

  before do
    @rulebase = PaloAlto::Models::Rulebase.new(name: name)
  end

  it "has a name attribute" do
    expect(@rulebase).to respond_to(:name)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Rulebase instance" do
      expect(@rulebase).to be_instance_of(PaloAlto::Models::Rulebase)
    end

    it "assigns name" do
      expect(@rulebase.name).to eq(name)
    end
  end
end
