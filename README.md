# Geppeto
Geppeto provides a Ruby API over two different transports, either a TCPSocket
or a serial connection, to the [Pinoccio microcontroller](https://pinocc.io). It
was created for Pinoccio applications that do not use Pinoccio's `hq.pinocc.io`
or `api.pinocc.io`. In my case, the Pinoccio microcontrollers existed on a LAN
that did not have an uplink or gateway to the internet.

## Install

`gem install geppeto`

or add it to your bundler file

`gem "geppeto", `~>0.1.0`

## Usage

The goal with Geppeto is to provide an API that feels like Ruby. Here's an
example:

```ruby
require 'geppeto'

serial = Geppeto::Connection::Serial.new
lead = Geppeto::Scout.new serial
lead.report
=> {"type"=>"scout", "lead"=>true, "version"=>1, "hardware"=>1, "family"=>1000, "serial"=>3001731, "sketch"=>"Custom", "build"=>-1, "revision"=>"unknown", "at"=>12642}
```

Here's an even better example:

```ruby
lead.pin.digital
=> {"type"=>"digital", "mode"=>[1, -3, -3, -3, -3, -3, -3], "state"=>[1, -1, -1, -1, -1, -1, -1], "at"=>9303}
```

You can even issue commands to all or others
```ruby
lead.all.led.on
=> nil
lead.others.led.off
=> nil
lead.led.report
=> {"type"=>"led", "led"=>[0, 255, 0], "torch"=>[0, 255, 0], "at"=>106676}
```

If that wasn't exciting enough, you can also delay commands
```ruby
lead.delay(5000).led.on
=> nil
# 5 seconds later... the led turned on.
```

### Creating a Scout

```ruby
id = 2
serial = Geppeto::Connection::Serial.new
scout = Geppeto::Scout.new serial, id
scout.report
=> nil
```

That's all well and good, but scout's that are accessible over a `Serial`
connection return `nil` all requests by result.  One way to obtain data is to
use a socket server.

### Socket Server

```ruby
socket = Geppeto::Connection::Server.new
=> #<Celluloid::CellProxy(Geppeto::Connection::Server:0x3fd00c8cb18c) @history=#<Revolver:0x007fa01918fe00 @array=[], @size=10, @unique=false> @logger=#<Logger:0x007fa01918fd88 @progname=nil, @level=0, @default_formatter=#<Logger::Formatter:0x007fa01918fd60 @datetime_format=nil>, @formatter=nil, @logdev=#<Logger::LogDevice:0x007fa01918fd10 @shift_size=nil, @shift_age=nil, @filename=nil, @dev=#<IO:<STDOUT>>, @mutex=#<Logger::LogDevice::LogDeviceMutex:0x007fa01918fce8 @mon_owner=nil, @mon_count=0, @mon_mutex=#<Mutex:0x007fa01918fc98>>>> @server=#<Celluloid::IO::TCPServer:0x007fa01918f950 @server=#<TCPServer:fd 11>>>
```

Now we have a socket server that will capture and parse the JSON responses.  

```ruby
lead.hq.setaddress("10.0.1.22")
=> nil
lead.wifi.reassociate
=> nil
socket.history
=> #<Revolver:0x007fee22ac9fa0
 @array=[{"type"=>"report", "from"=>2, "report"=>{"type"=>"temp", "c"=>31, "f"=>88, "offset"=>0, "at"=>3540003}}],
 @size=10,
 @unique=false>

```

Note that the socket server has a `history` attribute. Because of the limitations
with socket communication with pinoccio, we're capturing all of the responses in
a fixed sized LIFO array.

Nowe we can have our scout send us a report

```ruby
scout.hq.print("Hello, world!")
socket.history
=> #<Revolver:0x007fee22ac9fa0
 @array=
  [{"type"=>"report", "from"=>2, "report"=>{"type"=>"temp", "c"=>31, "f"=>88, "offset"=>0, "at"=>3540003}},
   {"type"=>"report", "from"=>1, "report"=>{"type"=>"temp", "c"=>32, "f"=>90, "offset"=>0, "at"=>197667}},
   {"type"=>"report", "from"=>2, "report"=>{"type"=>"temp", "c"=>30, "f"=>88, "offset"=>0, "at"=>3600003}},
   {"type"=>"announce", "from"=>2, "announce"=>[0, "Hello, world!"]}],
 @size=10,
 @unique=false>
 ```

 ### Constants

 Most of the time, arguments sent to the scouts are just strings and integers;
 however occasionally we may need to send a constant. This can be achieved by
 sending a ruby `Symbol` instead. Such is the case with pins, as seen here:

 ```ruby
 scout.pin.save("d2", :OUTPUT, :HIGH)
 socket.history.pop
=> {"type"=>"report",
 "from"=>2,
 "report"=>{"type"=>"digital", "mode"=>[1, -3, -3, -3, -3, -3, -3], "state"=>[1, -1, -1, -1, -1, -1, -1], "at"=>3938541}}
```

## What about...

### Tests
Well this is embarrassing... If I knew how to mock out a Pinoccio, Serial, or
Socket connection, I'd provide tests.  If you're interested in contributing, and
you know how to test this library, by all means, please send a pull request.

### Where did the "t" go?
Yes, Geppeto is purposely misspelled. If you're familiar with Pinoccio, you might
recognize that the "h" is missing.  This is explained on [Pinoccio's website](https://pinocc.io/faq#faq-wheres-the-h).

### What's missing?
Besides tests... a few things:

* [Events Callback Support](https://docs.pinocc.io/scoutcommands.html#event-callbacks)
* [Scout Acknowledgement Callback](https://docs.pinocc.io/scoutcommands.html#command-scout-ack)
* [Keys](https://docs.pinocc.io/scoutcommands.html#keys-deprecated)

### What's next?
Should there be a `Thor` backed CLI executable to manage a standalone socket server?
Or maybe I'll figure out how to write tests.
