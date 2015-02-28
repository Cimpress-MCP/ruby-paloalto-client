require "palo-alto/helpers/rest"
require "rest-client"

describe "PaloAlto::Helpers::Rest" do
  let(:url)            { "http://localhost.localdomain:443/api/" }
  let(:specified_opts) { { url:    url,
                           method: :post,
                           payload: {
                             type:   "config",
                             action: "set"
                           }
                         }
                       }
  let(:final_opts)     { { verify_ssl: OpenSSL::SSL::VERIFY_NONE,
                           headers: {
                             "User-Agent"   => "ruby-keystone-client",
                             "Accept"       => "application/xml",
                             "Content-Type" => "application/xml"
                           }
                         }.merge(specified_opts)
                       }

  describe "#make_request" do
    before do
      expect(RestClient::Request).to receive(:execute).with(final_opts).and_return(true)
    end

    it "makes the specified request" do
      expect(PaloAlto::Helpers::Rest.make_request(specified_opts)).to be_truthy
    end
  end
end
