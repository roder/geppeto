module Geppeto
  module Commands
    class Power
      def initialize(scout)
        @scout = scout
      end

      def charging?
        @scout.request("power.ischarging").to_i == 1
      end

      def battery?
        @scout.request("power.hasbattery").to_i == 1
      end

      def percent
        @scout.request("power.percent").to_i
      end

      def voltage
        @scout.request("power.voltage").to_i
      end

      def enablevcc
        @scout.request("power.enablevcc")
      end

      def disablevcc
        @scout.request("power.disablevcc")
      end

      def vcc?
        @scout.request("power.isvccenabled").to_i == 1
      end

      def sleep(ms, command = nil)
        @scout.request("power.sleep", ms, command)
      end

      def report
        @scout.request("power.report")
      end
    end
  end
end
