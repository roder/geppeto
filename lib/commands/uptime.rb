module Geppeto
  module Commands
    class Uptime

      def initialize(scout)
        @context = nil
        @scout = scout
      end

      def micros
        context ||= ".#{@context}" unless @context.nil?
        command = "uptime#{context}.micros"
        @scout.request(command)
        @context = nil
      end

      def seconds
        context ||= ".#{@context}" unless @context.nil?
        command = "uptime#{context}.seconds"
        @scout.request(command)
        @context = nil
      end

      def report
        @scout.request("uptime.report")
      end

      def getlastreset
        @scout.request("uptime.getlastreset")
      end

      def status
        @scout.request("uptime.status")
      end

      def awake
        @context = :awake
        self
      end

      def sleeping
        @context = :sleeping
        self
      end
    end
  end
end
