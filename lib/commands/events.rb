module Geppeto
  module Commands
    class Events
      def initialize(scout)
        @scout = scout
      end

      def start
        @scout.request("events.start")
      end

      def stop
        @scout.request("events.stop")
      end

      def setcycle(digitalMs, analogMs, peripheralMs)
        @scout.request("events.setcycle", digitalMs, analogMs, peripheralMs )
      end
    end
  end
end
