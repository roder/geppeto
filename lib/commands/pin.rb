module Geppeto
  module Commands
    class Pin
      def initialize(scout)
        @scout = scout
      end

      def makeinput(pin_name, input_type=:INPUT_PULLUP)
        @scout.request("pin.makeinput", pin_name, input_type)
      end

      def makeoutput(pin_name)
        @scout.request("pin.makeoutput", pin_name)
      end

      def makepwm(pin_name)
        @scout.request("pin.makepwm", pin_name)
      end

      def disable(pin_name)
        @scout.request("pin.disable", pin_name)
      end

      def setmode(pin_name, input_type=:INPUT_PULLUP)
        @scout.request("pin.setmode", pin_name, input_type)
      end

      def read(pin_name)
        @scout.request("pin.read", pin_name)
      end

      def write(pin_name, pin_value)
          @scout.request("pin.write", pin_name, pin_value)
      end

      def save(pin_name, pin_mode, pin_value = nil)
        @scout.request("pin.save", pin_name, pin_mode, pin_value)
      end

      def status
        @scout.request("pin.status")
      end

      def report
        self
      end

      def analog
        @scout.request("pin.report.analog")
      end

      def digital
        @scout.request("pin.report.digital")
      end
    end
  end
end
