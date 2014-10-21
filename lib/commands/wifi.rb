module Geppeto
  module Commands
    class Wifi
      def initialize(scout)
        @scout = scout
      end

      def report
        @scout.request("wifi.report")
      end

      def status
        @scout.request("wifi.status")
      end

      def list
        @scout.request("wifi.list", ms: 5)
      end

      def config(ssid, psk = nil)
        @scout.request("wifi.config", ssid, psk)
      end

      def dhcp(hostname)
        @scout.request("wifi.dhcp", hostname)
      end

      def static(ip, netmask, gateway, dns)
        @scout.request("wifi.static", ip, netmask, gateway, dns)
      end

      def reassociate
        @scout.request("wifi.reassociate")
      end

      def command(wifi_cmd)
        @scout.request("wifi.command", wifi_cmd)
      end
    end
  end
end
