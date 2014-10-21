module Geppeto
  module Commands
    class Memory
      def initialize(scout)
        @scout = scout
      end

      def report
        @scout.request("memory.report")
      end 
    end
  end
end
