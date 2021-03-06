module Geppeto
  module Commands
    class Led
      def initialize(scout)
        @scout = scout
      end

      def on?
        isoff().to_i != 1
      end

      def off?
        isoff().to_i == 1
      end

      def on
        @scout.request("led.on")
      end

      def off
        @scout.request("led.off")
      end

      def red(ms = nil, continuous = nil)
        @scout.request("led.red", ms, continuous)
      end

      def green(ms = nil, continuous = nil)
        @scout.request("led.green", ms, continuous)
      end

      def blue(ms = nil, continuous = nil)
        @scout.request("led.blue", ms, continuous)
      end

      def cyan(ms = nil, continuous = nil)
        @scout.request("led.cyan", ms, continuous)
      end

      def purple(ms = nil, continuous = nil)
        @scout.request("led.purple", ms, continuous)
      end

      def magenta(ms = nil, continuous = nil)
        @scout.request("led.magenta", ms, continuous)
      end

      def yellow(ms = nil, continuous = nil)
        @scout.request("led.yellow", ms, continuous)
      end

      def orange(ms = nil, continuous = nil)
        @scout.request("led.orange", ms, continuous)
      end

      def white(ms = nil, continuous = nil)
        @scout.request("led.white", ms, continuous)
      end

      def torch(ms = nil, continuous = nil)
        @scout.request("led.torch", ms, continuous )
      end

      def blink(red, green, blue, millis=500, continuous = nil)
        @scout.request("led.blink", red, green, blue, millis, continuous)
      end

      def sethex(hex_value)
        @scout.request("led.sethex", hex_value)
      end

      def gethex
        @scout.request("led.gethex")
      end

      def setrgb(red, green, blue)
        @scout.request("led.setrgb", red, green, blue)
      end

      def isoff
        @scout.request("led.isoff")
      end

      def report
        @scout.request("led.report")
      end
    end
  end
end
