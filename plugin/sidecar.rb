require 'tk'
require 'tkextlib/tkimg/png'
require 'tkextlib/tkimg/jpeg'
require 'tkextlib/tkimg/tiff'
require 'socket'
require 'thread'
require 'timeout'

Signal.trap(:INT){ exit(0) }
Signal.trap(:QUIT){ exit(0) }

TkRoot.new do
  title 'Sidecar'
end

$gs = TCPServer.open(ARGV[0])
addr = $gs.addr
addr.shift
printf("server is on %s\n", addr.join(":"))
printf("my pid is on %s\n", $$)




c = TkCanvas.new
$img = TkLabel.new
$img.image TkPhotoImage.new(file: File.expand_path('~/Desktop/uji.jpg'))
$img.image TkPhotoImage.new(file: File.expand_path('~/Desktop/zimbu.jpg'))
$img.pack

$path = false
$moge = false

TkTimer.start(100) do
  Thread.start($gs.accept) do |s| 
    $path = s.gets
    $moge = true
    s.close
  end
  # $path = false
  # begin
  #   Timeout.timeout 1.1 do
  #     Thread.start($gs.accept) do |s| 
  #       $path = s.gets
  #       $moge = true
  #       s.close
  #     end
  #   end
  # rescue TimeoutError
  # end
  # if $path
  #   $img.image TkPhotoImage.new(file: File.expand_path($path))
  # end
  if $moge
    $img.image TkPhotoImage.new(file: File.expand_path('~/Desktop/uji.jpg'))
    $moge = false
  else
    $img.image TkPhotoImage.new(file: File.expand_path('~/Desktop/chie.png'))
  end
end
Tk.mainloop



