module Geppeto
  module Commands
    class Temperature
      def initialize(scout)
        @scout = scout
      end

      def c
        @scout.request("temperature.c")
      end

      def f
        @scout.request("temperature.f")
      end

      def report
        @scout.request("temperature.report")
      end

      def setoffset(offset)
        @scout.request("temperature.offset", offset)
      end

      def calibrate(current_temp_c)
        @scout.request("temperature.calibrate", current_temp_c)
      end
    end
  end
end
