require "palo_alto/v6/security_rule_api"
require "palo_alto/helpers/rest"

describe "PaloAlto::V6::SecurityRuleApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::SecurityRuleApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  let(:security_rule_xml)            { File.open(fixture_file("security_rule.xml")).read }
  let(:security_rule_not_exist_xml)  { File.open(fixture_file("security_rule_not_exist.xml")).read }
  let(:security_rule_create_success) { File.open(fixture_file("security_rule_create_success.xml")).read }

  describe ".get_security_rule" do
    describe "when the security rule exists" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(security_rule_xml)
      end

      it "returns the security rule as JSON data" do
        expect(DummyClass.get_security_rule(name: "test1")).to be_instance_of(Hash)
      end
    end

    describe "when the security rule does not exist" do
      before do
        expect(PaloAlto::Helpers::Rest).to receive(:make_request).and_return(security_rule_not_exist_xml)
      end

      it "returns nil" do
        expect(DummyClass.get_security_rule(name: "bogusmissing")).to be_nil
      end
    end
  end

  describe ".create_security_rule" do
    it "returns the XML content response when the rule is successfully created" do
      pending("TODO: Create spec")
      fail
    end

    it "returns the XML content raw when the rule is successfully created but there is no internal msg" do
      pending("TODO: Create spec")
      fail
    end

    it "returns an exception when there is an HTTP issue" do
      pending("TODO: Create spec")
      fail
    end

    it "returns a JSON array of error data when the returned data contains a non-success code" do
      pending("TODO: Create spec")
      fail
    end
  end
end
