module Geppeto
  module Commands
    class Mesh
      def initialize(scout)
        @scout = scout
      end

      def config(scout_id, troop_id, channel=20)
        @scout.request("mesh.config", scout_id, troop_id, channel)
      end

      def setpowerlevel(level)
        @scout.request("mesh.setpowerlevel", level.to_i)
      end

      def setdatarate(rate)
        @scout.request("mesh.setdatarate", rate.to_i)
      end

      def setkey(key)
        @scout.request("mesh.setkey", key)
      end

      def resetkey
        @scout.request("mesh.resetkey")
      end

      def joingroup(group)
        @scout.request("mesh.joingroup", group.to_i)
      end

      def leavegroup(group)
        @scout.request("mesh.leavegroup", group.to_i)
      end

      def ingroup?(group)
        @scout.request("mesh.ingroup").to_i == 1
      end

      def report
        @scout.request("mesh.report")
      end

      def routing
        @scout.request("mesh.routing")
      end
    end
  end
end
