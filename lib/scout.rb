module Geppeto
  class Scout
    attr_reader :id
    attr_accessor :last_report
    attr_accessor :logger

    attr_reader :events
    attr_reader :hq
    attr_reader :led
    attr_reader :memory
    attr_reader :mesh
    attr_reader :pin
    attr_reader :power
    attr_reader :temperature
    attr_reader :uptime
    attr_reader :wifi

    def initialize(connection, id = nil)
      @id = id
      @conn = connection
      @options = Array.new
      @logger = @conn.logger ? @conn.logger : Logger.new(STDOUT)

      @events = Geppeto::Commands::Events.new(self)
      @hq  = Geppeto::Commands::Hq.new(self)
      @led = Geppeto::Commands::Led.new(self)
      @memory = Geppeto::Commands::Memory.new(self)
      @mesh = Geppeto::Commands::Mesh.new(self)
      @pin = Geppeto::Commands::Pin.new(self)
      @power = Geppeto::Commands::Power.new(self)
      @uptime = Geppeto::Commands::Uptime.new(self)
      @wifi = Geppeto::Commands::Wifi.new(self)
    end

    def all
      @options << :all
      self
    end

    def others
      @options << :others
      self
    end

    def report
      request("scout.report")
    end

    def lead?
      request("print scout.isleadscout").to_i == 1
    end

    def randomnumber
      request("randomnumber")
    end



    def delay(ms = nil)
      @options << :delay
      @_ms = ms
      self
    end

    def boot
      request("scout.boot")
    end

    def request(command, *args, ms: nil)
      args_string = join_args(args)
      command, args_string = process_options(command, args_string)

      case args_string.empty?
      when true
        unless @id.nil?
          command = "command.scout(#{@id}, \"#{command}\")"
        else
          command = "#{command}()"
        end
      when false
        unless @id.nil?
          command = "command.scout(#{@id}, \"#{command}\", #{args_string})"
        else
          command = "#{command}(#{args_string})"
        end
      end

      @logger.debug("Issuing: #{command}")
      @conn.write(command, ms)
    end

    private
    def process_options(command, arg_string)
      arg_string = "\"#{command}(#{arg_string})\"" unless @options.empty?
      case @options.shift
      when :all
        command = "command.all"
        process_options(command, arg_string)
      when :others
        command = "command.others"
        process_options(command, arg_string)
      when :delay
        command = "scout.delay"
        arg_string = "#{@_ms}, #{arg_string}"
        @_ms = false
        process_options(command, arg_string)
      else
        arg_string.gsub(/"/, "\\\"") unless arg_string.empty?
        return command, arg_string
      end
    end

    def join_args(args)
      arg_str = String.new
      n = 0
      args.each { |arg|
        if arg.class == String
          arg_str << "\"#{arg}\""
        else
          arg_str << arg.to_s
        end
        n += 1
        arg_str << ", " if n < args.length
      }
      arg_str
    end
  end
end
