require "palo-alto/models/policy"

describe "PaloAlto::Models::Policy" do
  let(:name) { "test-policy" }

  before do
    @policy = PaloAlto::Models::Policy.new(name: name)
  end

  it "has a name attribute" do
    expect(@policy).to respond_to(:name)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Policy instance" do
      expect(@policy).to be_instance_of(PaloAlto::Models::Policy)
    end

    it "assigns name" do
      expect(@policy.name).to eq(name)
    end
  end
end
