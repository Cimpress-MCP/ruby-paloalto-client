require "palo_alto/client"

describe "PaloAlto::Client" do
  let(:host)        { "some.host" }
  let(:port)        { "443" }
  let(:ssl)         { true }
  let(:username)    { "admin" }
  let(:password)    { "admin" }
  let(:api_version) { "6" }

  describe ".new" do
    let(:fake_api) { Class.new }

    it "attempts to create a new Api instance" do
      expect(Object).to receive(:const_get).and_return(fake_api)
      expect(fake_api).to receive(:new)

      PaloAlto::Client.new(host:        host,
                           port:        port,
                           ssl:         ssl,
                           username:    username,
                           password:    password,
                           api_version: api_version)
    end

    it "raises an exception for an un-implemented API version" do
      expect(File).to receive("exist?").and_return(false)
      expect{ PaloAlto::Client.new(host:        host,
                                   port:        port,
                                   ssl:         ssl,
                                   username:    username,
                                   password:    password,
                                   api_version: "BOGUS") }.to raise_exception
    end
  end
end
