require 'serialport'

module Geppeto
  module Connection
    class Serial
      attr_accessor :logger

      def initialize(port = false, baud = 115200, logger = nil)
        @logger = logger.nil? ? Logger.new(STDOUT) : logger
        port ||= `ls /dev`.split("\n").grep(/tty.usb/i).map{|d| "/dev/#{d}"}.first #TODO: Check that this works on RPi/Begalbone OSs
        @serial = SerialPort.new(port, baud)
        @serial.read_timeout = 100
        sleep 1
        begin
          @logger.debug(@serial.read_nonblock(4096))
        rescue EOFError
          # no data
        end
        @logger.info("Pinoccio Serial Connection started: #{port}")
      end

      def shutdown
        @serial.close if @serial
      rescue IOError
        @logger.warn("Pinoccio Serial Connection closed.")
      end

      def write(command, ms = nil)
        @serial.write command+"\n"
        ms ||= 0.1
        sleep ms
        read command
      end

      def read(command = nil)
        begin
          raw_result = @serial.read_nonblock(4096)
          if command.nil?
            raw_result
          else
            cmd = Regexp.escape(command)
            matches = /#{cmd}\r\n(?<response>.*)\r\n>\s.*/m.match(raw_result)
            if matches[:response]
              begin
                JSON.parse(matches[:response])
              rescue
                matches[:response]
              end
            else
              raw_result
            end
          end
        rescue
          nil
        end
      end

    end
  end
end
