require "palo_alto/models/log_entry"
require "palo_alto/models/system_log_entry"

describe "PaloAlto::Models::SystemLogEntry" do
  before do
    @system_log = PaloAlto::Models::SystemLogEntry.new(log_id: '129504701', serial: '001606017466', seqno: '3926388')
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::SystemLogEntry instance" do
      expect(@system_log).to be_instance_of(PaloAlto::Models::SystemLogEntry)
    end

    it "assigns the type as 'SYSTEM'" do
      expect(@system_log.type).to eq('SYSTEM')
    end
  end
end
