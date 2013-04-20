require 'qt4'
require 'socket'
require 'thread'

Signal.trap(:INT){ exit(0) }
Signal.trap(:QUIT){ exit(0) }




class Sidecar < Qt::MainWindow
  slots 'socket_wait()'

  def socket_wait
    sleep 0.1
    # loop do
    #   s = @gs.accept
    #   s.close
    # end


while false
  Thread.start(gs.accept) do |s| 
    print(s, " is accepted\n")
    puts(s.gets)
    print(s, " is gone\n")
    s.close
  end
end
   
    begin
      s = @gs.accept_nonblock
      path = s.gets
      puts "Opening #{path}"
      append_image path
      puts "Opened."
    rescue IO::WaitReadable, Errno::EINTR
      puts "rq"
      IO.select([@gs])
      retry
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




    $l = Qt::Label.new "Want to ride a sidecar? I'm here!"
    $l.resize 300, 50
    $l.setAlignment(Qt::AlignCenter)
    $l.show
    $l.raise
    
    
    @ruby_thread_timer = Qt::Timer.new self
    connect(@ruby_thread_timer, SIGNAL('timeout()'), SLOT('socket_wait()'))
    @ruby_thread_timer.start(0)
  end
  def append_image path
    $img = Qt::Image.new path
    $l.setPixmap Qt::Pixmap::fromImage $img
    $l.setSizePolicy Qt::SizePolicy::Ignored, Qt::SizePolicy::Ignored
    $l.setScaledContents false
    $l.adjustSize
  end
end

app = Qt::Application.new(ARGV)
f = Sidecar.new
app.exec
# while false
#   Thread.start(gs.accept) do |s| 
#     print(s, " is accepted\n")
#     puts(s.gets)
#     print(s, " is gone\n")
#     s.close
#   end
# end
