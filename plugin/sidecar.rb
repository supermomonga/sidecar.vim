require 'qt4'
require 'socket'
require 'thread'
require 'timeout'

Signal.trap(:INT){ exit(0) }
Signal.trap(:QUIT){ exit(0) }

class Sidecar < Qt::MainWindow
  slots 'socket_wait()'

  def socket_wait
    @path = nil
    begin
      Timeout.timeout 0.1 do
        Thread.start(@gs.accept) do |s| 
          @path = s.gets
          s.close
        end
      end
    rescue TimeoutError
    end
    if @path
      puts "Opening #{@path}"
      append_image @path
      puts "Opened."
    end
  end

  def initialize
    super

    # TCP server
    @gs = TCPServer.open(ARGV[0])
    addr = @gs.addr
    addr.shift
    printf("server is on %s\n", addr.join(":"))
    printf("my pid is on %s\n", $$)

    @l = Qt::Label.new "Want to ride a sidecar? I'm here!"
    @l.resize 300, 50
    @l.setAlignment(Qt::AlignCenter)
    @l.show
    # raise takes focus from Vim.
    # @l.raise
    
    @ruby_thread_timer = Qt::Timer.new self
    connect(@ruby_thread_timer, SIGNAL('timeout()'), SLOT('socket_wait()'))
    @ruby_thread_timer.start(0)
  end
  def append_image path
    $img = Qt::Image.new path
    @l.setPixmap Qt::Pixmap::fromImage $img
    @l.setSizePolicy Qt::SizePolicy::Ignored, Qt::SizePolicy::Ignored
    @l.setScaledContents false
    @l.adjustSize
  end
end

app = Qt::Application.new(ARGV)
f = Sidecar.new
app.exec


