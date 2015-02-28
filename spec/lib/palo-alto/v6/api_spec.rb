require "palo-alto/v6/api"

describe "PaloAlto::V6::Api" do
  let(:host)        { "some.host" }
  let(:port)        { "443" }
  let(:ssl)         { true }
  let(:username)    { "admin" }
  let(:password)    { "admin" }
  let(:api_version) { "6" }

  before do
    @api = PaloAlto::V6::Api.new(host:     host,
                                 port:     port,
                                 ssl:      ssl,
                                 username: username,
                                 password: password)
  end

  it "has a host attribute" do
    expect(@api).to respond_to(:host)
  end

  it "has a port attribute" do
    expect(@api).to respond_to(:port)
  end

  it "has a ssl attribute" do
    expect(@api).to respond_to(:ssl)
  end

  it "has a username attribute" do
    expect(@api).to respond_to(:username)
  end

  it "has a password attribute" do
    expect(@api).to respond_to(:password)
  end

  describe ".initialize" do
    it "returns a PaloAlto::V6::Api instance" do
      expect(@api).to be_instance_of(PaloAlto::V6::Api)
    end

    it "assigns host" do
      expect(@api.host).to eq(host)
    end

    it "assigns port" do
      expect(@api.port).to eq(port)
    end

    it "assigns ssl" do
      expect(@api.ssl).to eq(ssl)
    end

    it "assigns username" do
      expect(@api.username).to eq(username)
    end

    it "assigns password" do
      expect(@api.password).to eq(password)
    end

    describe "for inability to obtain api_key with parameters" do
      it "raises an exception" do
      end
    end
  end
end
