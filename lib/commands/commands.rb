require 'commands/events'
require 'commands/hq'
require 'commands/led'
require 'commands/memory'
require 'commands/mesh'
require 'commands/pin'
require 'commands/power'
require 'commands/uptime'
require 'commands/wifi'

module Geppeto
  module Commands
    class NotLeadScout < Exception
    end
  end
end
