require 'celluloid/io'
require 'revolver'

module Geppeto
  module Connection
    class Server
      include Celluloid::IO
      finalizer :shutdown

      attr_accessor :logger
      attr_accessor :history

      def initialize(host="0.0.0.0", port = 22756, logger = nil)
        @history = Revolver.new(10)
        @logger = logger.nil? ? ::Logger.new(STDOUT) : logger
        @logger.info("Starting Pinoccio Server on #{host}:#{port}")
        @server = TCPServer.new(host, port)
        async.run
      end

      def shutdown
        @server.close if @server
      rescue IOError
        @logger.warn("Pinoccio Server shutting down")
      end

      def format_cmd(scout, command)
        cmd = {
          :to => scout.to_i,
          :command => command.to_s,
          :id => 1,
          :timeout => 10000,  # TODO: Make this configurable.
          :type => "command",
        }
        cmd.to_json + "\n"
      end

      def send(scout, command)
        @logger.debug("Scout #{scout}: #{command}")
        if @socket.nil?
          @logger.warn("No socket connected")
        else
          @socket.write format_cmd(scout, command)
        end
      end

      def run
        loop { async.handle_connection @server.accept }
      end

      def handle_connection(socket)
        _, port, host = socket.peeraddr
        @logger.info("Connected: #{host}:#{port}")
        chunk = socket.gets
        data = JSON.parse(chunk)
        token = data["token"]
        @socket = socket
        @logger.debug("Connected token: #{token}")
        loop {
          chunk = @socket.gets.chomp!
          data = JSON.parse(chunk)
          @history << data
          @logger.debug("Received: #{data}")
        }
      rescue
        @logger.info("Disconnected: #{host}:#{port}")
        @socket.close
        @logger.debug("Removed token: #{token}")
        @socket = nil
      end
    end
  end
end
