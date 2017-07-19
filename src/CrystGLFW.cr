require "./crystglfw/**"

module CrystGLFW
  extend self

  alias ErrorCallback = Proc(Int32, Nil)

  @@error_callback = ErrorCallback.new do |error_code|
    raise Error.generate(error_code)
  end

  # Sets the error callback that is called when an error occurs in LibGLFW.
  #
  # When an error occurs in LibGLFW, an error code is yielded to the block
  # defined by this method. The error code identifies the type of error that
  # occurred and can be validated by checking it against the constants defined
  # in CrystGLFW:
  #
  # ```
  # CrystGLFW.on_error do |error_code|
  #   case error_code
  #   when CrystGLFW[:not_initialized]
  #     puts "CrystGLFW has not been initialized."
  #   when CrystGLFW[:invalid_enum]
  #     puts "An invalid enum was passed to CrystGLFW."
  #   else
  #     puts "An error occurred"
  #   end
  # end
  # ```
  #
  # NOTE: This method may be called outside a `#run` block definition without
  # triggering an error.
  # NOTE: Defining custom behavior will bypass the `Error` module entirely. It
  # is recommended that this method not be used.
  def self.on_error(&callback : ErrorCallback)
    @@error_callback = callback
  end

  # Sets up GLFW to execute the block and terminates GLFW afterwards.
  #
  # ```
  # include CrystGLFW
  #
  # CrystGLFW.run do
  #   window = Window.new(title: "My Window")
  #   until window.should_close?
  #     window.wait_events
  #     window.swap_buffers
  #   end
  # end
  # ```
  #
  # With few exceptions, all CrystGLFW methods must be called within the block
  # passed to this method. This method initializes the underlying GLFW library
  # for use and cleans up the library after the block has returned.
  def self.run(&block)
    LibGLFW.init
    yield
    LibGLFW.terminate
  end

  # Returns the major, minor, and revision version numbers of GLFW.
  #
  # ```
  # CrystGLFW.version # => {major: 3, minor: 2, rev: 1}
  # ```
  #
  # NOTE: This method may be called outside a `#run` block definition without
  # triggering an error.
  def self.version
    LibGLFW.get_version(out major, out minor, out rev)
    {major: major, minor: minor, rev: rev}
  end

  # Returns the compile-time generated version string of GLFW.
  #
  # ```
  # CrystGLFW.version_string # => "3.2.1 Cocoa NSGL chdir menubar retina dynamic"
  # ```
  #
  # NOTE: This method may be called outside a `#run` block definition without
  # triggering an error.
  def self.version_string
    String.new(LibGLFW.get_version_string)
  end

  # Returns the current value, in seconds, of the GLFW timer.
  #
  # ```
  # CrystGLFW.time # => 0.13899576
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  def self.time
    LibGLFW.get_time
  end

  # Sets the GLFW timer to a new time, in seconds.
  #
  # This method accepts the following arguments:
  # - *t*, the new time.
  #
  # ```
  # CrystGLFW.time = 1.0
  # CrystGLFW.time # => 1.0
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  def self.time=(t : Float64)
    LibGLFW.set_time t
  end

  # Returns the current value of the raw timer, measured in
  # 1 / `#timer_frequency` seconds.
  #
  # ```
  # CrystGLFW.timer_value # => 754_104_002_009_408
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  def self.timer_value
    LibGLFW.get_timer_value
  end

  # Returns the frequency, in Hz, of the raw timer.
  #
  # ```
  # CrystGLFW.timer_frequency # => 1_000_000_000
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  def self.timer_frequency
    LibGLFW.get_timer_frequency
  end

  # Processes all events in the event queue and then returns immediately.
  #
  # ```
  # include CrystGLFW
  #
  # CrystGLFW.run do
  #   window = Window.new
  #   until window.should_close?
  #     CrystGLFW.poll_events # Process all events, even if queue is empty.
  #     window.swap_buffers
  #   end
  # end
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  # NOTE: This method must not be called from within a callback.
  def self.poll_events
    LibGLFW.poll_events
  end

  # Puts the calling thread to sleep until at least one event is queued.
  #
  # ```
  # include CrystGLFW
  #
  # CrystGLFW.run do
  #   window = Window.new
  #   until window.should_close?
  #     CrystGLFW.wait_events # Wait for events to queue, then process them.
  #     window.swap_buffers
  #   end
  # end
  #
  # NOTE: This method must be called inside a `#run` block definition.
  # NOTE: This method must not be called from within a callback.
  def self.wait_events
    LibGLFW.wait_events
  end

  # Puts the calling thread to sleep until at least one event is queued or the specified timeout is reached.
  #
  # ```
  # include CrystGLFW
  #
  # CrystGLFW.run do
  #   window = Window.new
  #   until window.should_close?
  #     CrystGLFW.wait_events(1.5)
  #     window.swap_buffers
  #   end
  # end
  #
  # This method accepts the following arguments:
  # - *timeout*, the maximum amount of time, in seconds, to wait.
  #
  # NOTE: This method must be called inside a `#run` block definition.
  # NOTE: This method must not be called from within a callback.
  def self.wait_events(timeout : Float64)
    LibGLFW.wait_events_timeout(timeout)
  end

  # Posts an empty event to the event queue, forcing `#wait_events` to return.
  #
  # ```
  # CrystGLFW.post_empty_event
  # ```
  #
  # NOTE: This method must be called inside a `#run` block definition.
  def self.post_empty_event
    LibGLFW.post_empty_event
  end

  # Sets the immutable error callback shim.
  private def self.set_error_callback
    callback = LibGLFW::Errorfun.new do |error_code, description|
      @@error_callback.call error_code
    end
    LibGLFW.set_error_callback callback
  end

  set_error_callback
end

CrystGLFW.run do
  window = CrystGLFW::Window.new(title: "Example Window")

  cursor = CrystGLFW::Cursor.new(:hand_cursor)
  window.cursor = cursor

  window.on_close do
    puts "bye!"
  end

  window.on_move do |x, y|
    puts "window moved to (#{x}, #{y})"
    puts window.edges
  end

  window.on_resize do |width, height|
    puts "window resized to #{width} x #{height}"
  end

  window.on_framebuffer_resize do |width, height|
    puts "framebuffer resized to #{width} x #{height}"
  end

  window.on_cursor_move do |x, y|
    puts "(#{x}, #{y})" if window.contains? x, y
  end

  window.on_toggle_focus do
    if window.focused?
      puts "I am now focused!"
    else
      puts "Why have you forsaken me?"
    end
  end

  window.on_cursor_cross_threshold do
    cp = window.cursor_position
    puts "Cursor position: #{cp}"
    puts "Cursor in window? #{window.contains? **cp}"
  end

  window.on_key do |key_event|
    # puts key_event.key.name if key_event.key.printable? && key_event.press?
  end

  window.on_char do |char_event|
    puts char_event.char
  end

  window.on_mouse_button do |mbe|
    puts "Action: #{mbe.action}" if mbe.mouse_button.is? :mouse_button_right
  end

  window.on_scroll do |x, y|
    puts "x: #{x}, y: #{y}"
  end

  window.on_file_drop do |paths|
    paths.each { |p| puts p }
  end

  monitor = CrystGLFW::Monitor.primary
  puts monitor.gamma_ramp.red

  until window.should_close?
    CrystGLFW.wait_events
    window.swap_buffers
  end

  window.destroy
end
