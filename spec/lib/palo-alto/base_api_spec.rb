require "palo-alto/base-api"
require "palo-alto/helpers/rest"

describe "PaloAlto::BaseApi" do
  let(:host)          { "some.host" }
  let(:port)          { "443" }
  let(:ssl)           { false }
  let(:username)      { "admin" }
  let(:password)      { "admin" }
  let(:api_version)   { "6" }
  let(:url)           { "http://#{host}:#{port}/api/" }
  let(:auth_key)      { "039th90hg092h" }
  let(:auth_response) { "<response status=\"success\">
                           <result>
                             <key>#{auth_key}</key>
                           </result>
                         </response>" }

  before do
    FakeWeb.clean_registry
    FakeWeb.register_uri(:get, url, :status => [ 200 ], :body => auth_response)

    @api = PaloAlto::BaseApi.new(host:     host,
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

  it "has an auth_key attribute" do
    expect(@api).to respond_to(:auth_key)
  end

  describe ".initialize" do
    it "returns a PaloAlto::V6::Api instance" do
      expect(@api).to be_instance_of(PaloAlto::BaseApi)
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

    it "obtains and assigns the auth_key" do
      expect(@api.auth_key).to eq(auth_key)
    end

    describe "when an auth_key cannot be obtained" do
      before do
        FakeWeb.clean_registry
        FakeWeb.register_uri(:get, url, :status => [ 401 ], :body => File.open(fixture_file("failure.xml")).read)
      end

      it "throws and exception" do
        expect{ PaloAlto::BaseApi.new(host:     host,
                                      port:     port,
                                      ssl:      ssl,
                                      username: username,
                                      password: password) }.to raise_exception
      end
    end
  end

  describe ".endpoint" do
    it "returns the endpoint with secure protocol" do
      url = "http://#{host}:#{port}/api/"
      expect(@api.endpoint).to eq(url)
    end
  end

  describe "private method" do
    describe ".get_auth_key" do
      it "returns the resulting auth_key from a request" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(auth_response)

        expect(@api.send(:get_auth_key)).to eq(auth_key)
      end

      it "returns nil when a HTTP request attempt is unsuccessful" do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(File.open(fixture_file("failure.xml")).read)

        expect(@api.send(:get_auth_key)).to be_nil
      end
    end
  end
end
