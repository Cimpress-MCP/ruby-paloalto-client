module PaloAlto
  module Models
    # Currently, Rulebase is a stand-in for "Security"
    # TODO: Add different Rulebase types (Security, NAT, etc)
    class Rulebase
      attr_accessor :name, :action, :from_zones, :to_zones, :sources, :destinations,
                    :source_users, :services, :categories, :applications, :hip_profiles,
                    :log_session_start, :log_session_end

      # Create and returns a new PaloAlto::Models::Rulebase instance with the given parameters
      #
      # == Attributes
      #
      # * +name+              - Name of the rulebase
      # * +action+            - Type of rule (deny, allow, etc)
      # * +from_zones+        - User-defined source zones
      # * +to_zones+          - User-defined destination zones
      # * +sources+           - Source IP addresses or networks
      # * +destinations+      - Destination IP addresses or networks
      # * +source_users+      - Users defined for the source
      # * +services+          - Services defined that the rule applies to
      # * +categories+        - User-defined categories that the rule applies to
      # * +applications+      - Applications defined that the rule applies to
      # * +hip_profiles+      - Host information profile for defined hosts
      # * +log_session_start+ - Whether to log the session start event for captured traffic
      # * +log_session_end+   - Whether to log the session end even for captured traffic
      #
      # == Example
      #
      #  PaloAlto::Models::Rulebase.new name: 'rulebase-1'
      def initialize(name:, action:, from_zones:, to_zones:, sources:, destinations:, source_users:,
                     services:, categories:, applications:, hip_profiles:, log_session_start:, log_session_end:)
        self.name              = name
        self.action            = action
        self.from_zones        = from_zones
        self.to_zones          = to_zones
        self.sources           = sources
        self.destinations      = destinations
        self.source_users      = source_users
        self.services          = services
        self.categories        = categories
        self.applications      = applications
        self.hip_profiles      = hip_profiles
        self.log_session_start = log_session_start
        self.log_session_end   = log_session_end

        self
      end
    end
  end
end
