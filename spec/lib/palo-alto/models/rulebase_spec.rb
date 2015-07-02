require "palo_alto/models/rulebase"

describe "PaloAlto::Models::Rulebase" do
  let(:name)              { "test-rulebase" }
  let(:action)            { "deny" }
  let(:from_zones)        { [ "a", "b" ] }
  let(:to_zones)          { [ "c", "d" ] }
  let(:sources)           { [ "1.2.3.4", "5.6.7.8/23" ] }
  let(:destinations)      { [ "4.3.2.2", "6.5.3.2/23" ] }
  let(:source_users)      { [ "user1", "user2" ] }
  let(:services)          { [ "service1", "service2" ] }
  let(:categories)        { [ "category1", "category2" ] }
  let(:applications)      { [ "application1", "application2" ] }
  let(:hip_profiles)      { [ "profile1", "profile2" ] }
  let(:log_session_start) { "true" }
  let(:log_session_end)   { "false" }

  before do
    @rulebase = PaloAlto::Models::Rulebase.new(name:              name,
                                               action:            action,
                                               from_zones:        from_zones,
                                               to_zones:          to_zones,
                                               sources:           sources,
                                               destinations:      destinations,
                                               source_users:      source_users,
                                               services:          services,
                                               categories:        categories,
                                               applications:      applications,
                                               hip_profiles:      hip_profiles,
                                               log_session_start: log_session_start,
                                               log_session_end:   log_session_end)
  end

  it "has a name attribute" do
    expect(@rulebase).to respond_to(:name)
  end

  it "has a action attribute" do
    expect(@rulebase).to respond_to(:action)
  end

  it "has a from_zones attribute" do
    expect(@rulebase).to respond_to(:from_zones)
  end

  it "has a to_zones attribute" do
    expect(@rulebase).to respond_to(:to_zones)
  end

  it "has a sources attribute" do
    expect(@rulebase).to respond_to(:sources)
  end

  it "has a destinations attribute" do
    expect(@rulebase).to respond_to(:destinations)
  end

  it "has a source_users attribute" do
    expect(@rulebase).to respond_to(:source_users)
  end

  it "has a services attribute" do
    expect(@rulebase).to respond_to(:services)
  end

  it "has a categories attribute" do
    expect(@rulebase).to respond_to(:categories)
  end

  it "has a applications attribute" do
    expect(@rulebase).to respond_to(:applications)
  end

  it "has a hip_profiles attribute" do
    expect(@rulebase).to respond_to(:hip_profiles)
  end

  it "has a log_session_start attribute" do
    expect(@rulebase).to respond_to(:log_session_start)
  end

  it "has a log_session_end attribute" do
    expect(@rulebase).to respond_to(:log_session_end)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::Rulebase instance" do
      expect(@rulebase).to be_instance_of(PaloAlto::Models::Rulebase)
    end

    it "assigns name" do
      expect(@rulebase.name).to eq(name)
    end

    it "assigns action" do
      expect(@rulebase.action).to eq(action)
    end

    it "assigns from_zones" do
      expect(@rulebase.from_zones).to eq(from_zones)
    end

    it "assigns to_zones" do
      expect(@rulebase.to_zones).to eq(to_zones)
    end

    it "assigns sources" do
      expect(@rulebase.sources).to eq(sources)
    end

    it "assigns destinations" do
      expect(@rulebase.destinations).to eq(destinations)
    end

    it "assigns source_users" do
      expect(@rulebase.source_users).to eq(source_users)
    end

    it "assigns services" do
      expect(@rulebase.services).to eq(services)
    end

    it "assigns categories" do
      expect(@rulebase.categories).to eq(categories)
    end

    it "assigns applications" do
      expect(@rulebase.applications).to eq(applications)
    end

    it "assigns hip_profiles" do
      expect(@rulebase.hip_profiles).to eq(hip_profiles)
    end

    it "assigns log_session_start" do
      expect(@rulebase.log_session_start).to eq(log_session_start)
    end

    it "assigns log_session_end" do
      expect(@rulebase.log_session_end).to eq(log_session_end)
    end
  end
end
