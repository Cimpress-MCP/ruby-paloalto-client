require "palo_alto/models/log_entry"
require "palo_alto/models/traffic_log_entry"

describe "PaloAlto::Models::TrafficLogEntry" do
  before do
    @traffic_log = PaloAlto::Models::TrafficLogEntry.new(id: '129504701', serial: '001606017466', seqno: '3926388')
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::TrafficLogEntry instance" do
      expect(@traffic_log).to be_instance_of(PaloAlto::Models::TrafficLogEntry)
    end

    it "assigns the type as 'TRAFFIC'" do
      expect(@traffic_log.type).to eq('TRAFFIC')
    end
  end
end
