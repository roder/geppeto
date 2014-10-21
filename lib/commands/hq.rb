module Geppeto
  module Commands
    class Hq
      def initialize(scout)
        @scout = scout
      end

      def setaddress(host, port = nil)
        @scout.request("hq.setaddress", host, port)
      end

      def print(str)
        @scout.request("hq.print", str)
      end

      def settoken(token)
        @scout.request("hq.settoken", token)
      end

      def gettoken
        @scout.request("hq.gettoken")
      end

      def report(report_name, value)
        @scout.request("hq.report", report_name, value)
      end
    end
  end
end
