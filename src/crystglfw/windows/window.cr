require "lib_glfw"

module CrystGLFW
  # A Window represents a GLFW Window and its associated OpenGL context.
  struct Window
    alias MoveCallback = Proc(Event::WindowMove, Nil)
    alias ResizeCallback = Proc(Event::WindowResize, Nil)
    alias CloseCallback = Proc(Event::WindowClose, Nil)
    alias RefreshCallback = Proc(Event::WindowRefresh, Nil)
    alias ToggleFocusCallback = Proc(Event::WindowToggleFocus, Nil)
    alias ToggleIconificationCallback = Proc(Event::WindowToggleIconification, Nil)
    alias FramebufferResizeCallback = Proc(Event::WindowFramebufferResize, Nil)
    alias KeyCallback = Proc(Event::WindowKey, Nil)
    alias CharCallback = Proc(Event::WindowChar, Nil)
    alias MouseButtonCallback = Proc(Event::WindowMouseButton, Nil)
    alias ScrollCallback = Proc(Event::WindowScroll, Nil)
    alias CursorCrossThresholdCallback = Proc(Event::WindowCursorCrossThreshold, Nil)
    alias CursorMoveCallback = Proc(Event::WindowCursorMove, Nil)
    alias FileDropCallback = Proc(Event::WindowFileDrop, Nil)

    alias WindowCallback = MoveCallback |
                           ResizeCallback |
                           CloseCallback |
                           RefreshCallback |
                           ToggleFocusCallback |
                           ToggleIconificationCallback |
                           FramebufferResizeCallback |
                           KeyCallback |
                           CharCallback |
                           MouseButtonCallback |
                           ScrollCallback |
                           CursorCrossThresholdCallback |
                           CursorMoveCallback |
                           FileDropCallback |
                           Nil

    # A callback registry that maps a unique LibGLFW Window pointer to a callback.
    # This allows multiple window objects to reference the same underlying GLFW window and
    # define callbacks for it universally.
    @@callback_registry = {} of Pointer(LibGLFW::Window) => Hash(Symbol, WindowCallback)

    # A cursor registry that maps a unique LibGLFW Window pointer to a cursor object.
    # This allows multiple windows to reference the same cursor object.
    @@cursor_registry = {} of Pointer(LibGLFW::Window) => Cursor

    # A title registry that maps a unique LibGLFW Window pointer to its title, which is not retrievable by GLFW.
    # This allows multiple window objects to reference the same underlying GLFW window and retrieve its title.
    @@title_registry = {} of Pointer(LibGLFW::Window) => String

    # Returns the window whose context is current.
    #
    # ```
    # current_window = CrystGLFW::Window.current
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.current : Window
      candidate = LibGLFW.get_current_context
      if candidate.null?
        raise Error.generate(:no_current_context)
      else
        new(LibGLFW.get_current_context)
      end
    end

    # :nodoc:
    def self.set_hints(hints : Hash(Symbol, Int32 | Symbol | Bool))
      hints.each do |key, value|
        hint_value = nil
        if value.is_a? Symbol
          hint_value = CrystGLFW[value]
        elsif value.is_a? Int32
          hint_value = value
        else
          hint_value = value == true ? CrystGLFW[:true] : CrystGLFW[:false]
        end
        LibGLFW.window_hint CrystGLFW[key], hint_value
      end
    end

    # :nodoc:
    def self.clear_hints
      LibGLFW.default_window_hints
    end

    # Creates a new GLFW window.
    #
    # ```
    # # Create a window that is 640x480, titled "My Test Window".
    # window = CrystGLFW::Window.new(width: 640, height: 480, title: "My Test Window")
    # ```
    #
    # This method accepts the following arguments:
    # - *width*, the desired width of the window in screen coordinates.
    # - *height*, the desired height of the window in screen coordinates.
    # - *title*, the title of the window.
    # - *monitor*, the monitor to use for full screen mode. If left blank, the context will run in windowed mode.
    # - *sharing_window*, the window whose context to share resources with. If left blank, no resource sharing occurs.
    # - *hints*, the desired window options. If left blank, GLFW defaults will be used.
    #
    # There are several different kinds of hints that can be set, all of which can be found in the GLFW documentation.
    # To specify hints for window creation, create a hash:
    #
    # ```
    # hints = {:client_api => :opengl_es_api, :context_version_major => 3}
    # window = CrystGLFW::Window.new(title: "My Window", monitor: CrystGLFW::Monitor.primary, hints: hints)
    # ```
    #
    # Hints are cleared after window creation, so they are only used when passed.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def initialize(width = 640, height = 480, title = "", monitor = nil, sharing_window = nil, hints = nil)
      Window.set_hints(hints) if hints
      @handle = LibGLFW.create_window width, height, title, monitor, sharing_window
      @@title_registry[@handle] = title
      Window.clear_hints if hints
      initialize_callbacks unless @@callback_registry[@handle]?
    end

    # :nodoc:
    def initialize(handle : Pointer(LibGLFW::Window))
      @handle = handle
      initialize_callbacks unless @@callback_registry[@handle]?
    end

    # Destroys the underlying GLFW Window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def destroy
      remove_cursor
      @@callback_registry.delete @handle
      @@title_registry.delete @handle
      LibGLFW.destroy_window @handle
    end

    # Returns true if the window is currently marked for closing. False otherwise.
    #
    # ```
    # until window.should_close?
    #   window.wait_events
    #   window.swap_buffers
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def should_close? : Bool
      LibGLFW.window_should_close(@handle) == CrystGLFW[:true]
    end

    # Marks this window for closing.
    #
    # ```
    # window.on_key do |key_event|
    #   # if the 'q' key is held down, then mark the window for closing.
    #   if key_event.key.is? :key_q && key_event.repeat?
    #     window.should_close
    #   end
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def should_close
      LibGLFW.set_window_should_close @handle, CrystGLFW[:true]
    end

    # The exact opposite of `#should_close`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def should_not_close
      LibGLFW.set_window_should_close @handle, CrystGLFW[:false]
    end

    # Returns the window's title.
    #
    # ```
    # window.title = "Test Title"
    # window.title # => "Test Title"
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def title : String
      @@title_registry[@handle]
    end

    # Sets the window's title.
    #
    # ```
    # window.on_key |key_event|
    #   # If the key is printable, then set the window title to the name of the key.
    #   window.set_title key_event.key.name if key_event.key.printable? && key_event.press?
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *title*, the desired title of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_title(title : String)
      LibGLFW.set_window_title @handle, title
      @@title_registry[@handle] = title
    end

    # Alternate syntax for `#set_title`.
    #
    # ```
    # window.on_key do |key_event|
    #   # If the key is printable, then set the window title to the name of the key.
    #   window.title = key_event.key.name if key_event.key.printable? && key_event.press?
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *title*, the desired title of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def title=(title : String)
      set_title title
    end

    # Returns the position of the window, in screen coordinates, as a named tuple.
    #
    # ```
    # pos = window.position
    # puts "The window's top left corner is at (#{pos[:x]}, #{pos[:y]})."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position : NamedTuple(x: Int32, y: Int32)
      LibGLFW.get_window_pos @handle, out x, out y
      {x: x, y: y}
    end

    # Sets the position of the window.
    #
    # ```
    # # Set the window's top left corner at (150, 150).
    # window.set_position 150, 150
    # ```
    #
    # This method accepts the following arguments:
    # - *x*, the x-coordinate of the desired position.
    # - *y*, the y-coordinate of the desired position.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_position(x : Int32, y : Int32)
      LibGLFW.set_window_pos @handle, x, y
    end

    # Alternate syntax for `#set_position`.
    #
    # ```
    # # Set the window's top left corner at (150, 150).
    # window.position = {x: 150, y: 150}
    # ```
    #
    # This method accepts the following arguments:
    # - *pos*, the desired position of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position=(pos : NamedTuple(x: Int32, y: Int32))
      set_position pos[:x], pos[:y]
    end

    # Returns the size of the window, in screen coordinates, as a named tuple.
    #
    # ```
    # size = window.size
    # puts "The window is currently #{size[:width]} x #{size[:height]}"
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def size : NamedTuple(width: Int32, height: Int32)
      LibGLFW.get_window_size @handle, out width, out height
      {width: width, height: height}
    end

    # Sets the size of the window.
    #
    # ```
    # # Set the window's size to be 640x480.
    # window.set_size 640, 480
    # ```
    #
    # This method accepts the following arguments:
    # - *width*, the desired width of the window.
    # - *height*, the desired height of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_size(width : Int32, height : Int32)
      LibGLFW.set_window_size @handle, width, height
    end

    # Alternate syntax for `#set_size`.
    #
    # ```
    # # Set the window's size to be 640x480.
    # window.size = {width: 640, height: 480}
    # ```
    #
    # This method accepts the following arguments:
    # - *s*, the desired size of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def size=(s : NamedTuple(width: Int32, height: Int32))
      set_size s[:width], s[:height]
    end

    # Returns the corners of the window.
    #
    # ```
    # window.position = {x: 100, y: 100}
    #
    # # Retrieve the window's corners.
    # c = window.corners
    #
    # # Get the top left corner coordinates.
    # tl = c[:top_left]
    #
    # # Print the coordinates.
    # puts "Top Left: (#{tl[:x]}, #{tl[:y]})" # => "Top Left: (100, 100)"
    # ```
    #
    # Each corner is labeled accordingly: top_left, top_right, bottom_right, bottom_left
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def corners : NamedTuple(top_left: NamedTuple(x: Int32, y: Int32),
    top_right: NamedTuple(x: Int32, y: Int32),
    bottom_left: NamedTuple(x: Int32, y: Int32),
    bottom_right: NamedTuple(x: Int32, y: Int32))
      p, s = position, size
      tl = p
      br = {x: (tl[:x] + s[:width]), y: (tl[:y] + s[:height])}
      tr = {x: br[:x], y: tl[:y]}
      bl = {x: tl[:x], y: br[:y]}
      {top_left: tl, top_right: tr, bottom_right: br, bottom_left: bl}
    end

    # Returns true if the window contains the given coordinates. False otherwise.
    #
    # ```
    # window.position = {x: 100, y: 100}
    # window.size = {width: 100, height: 100}
    #
    # # Check if the location (150, 150) is inside the window.
    # window.contains? 150, 150 # => true
    #
    # # Check if the location (1000, 1000) is inside the window.
    # window.contains? 1000, 1000 # => false
    # ```
    #
    # This method accepts the following arguments:
    # - *x*, the x-coordinate to check.
    # - *y*, the y-coordinate to check.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def contains?(x : Number, y : Number) : Bool
      c = corners
      tl, br = c[:top_left], c[:bottom_right]
      x >= tl[:x] && x <= br[:x] && y >= tl[:y] && y <= br[:y]
    end

    # Alternate syntax for `#contains?`.
    #
    # ```
    # window.position = {x: 100, y: 100}
    # window.size = {width: 100, height: 100}
    #
    # # Check if the location (150, 150) is inside the window.
    # window.contains? {x: 150, y: 150} # => true
    #
    # # Check if the location (1000, 1000) is inside the window.
    # window.contains? {x: 1000, y: 1000} # => false
    # ```
    #
    # This method accepts the following arguments:
    #  -*coordinates*, the coordinates to check.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def contains?(coordinates : NamedTuple(x: Number, y: Number)) : Bool
      contains? coordinates[:x], coordinates[:y]
    end

    # Sets the size limits of the window.
    #
    # ```
    # # Disallows the window to be resized smaller than 100x100.
    # window.set_size_limits min_width: 100, min_height: 100
    #
    # # Disallows the window to be resized larger than 640x480.
    # window.set_size_limits max_width: 640, max_height: 480
    # ```
    #
    # This method accepts the following arguments:
    # - *min_width*, the minimum width of the window, in screen coordinates.
    # - *min_height*, the minimum height of the window, in screen coordinates.
    # - *max_width*, the maximum width of the window, in screen coordinates.
    # - *max_height*, the maximum height of the window, in screen coordinates.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_size_limits(min_width : Int32 = CrystGLFW[:dont_care], min_height : Int32 = CrystGLFW[:dont_care],
                        max_width : Int32 = CrystGLFW[:dont_care], max_height : Int32 = CrystGLFW[:dont_care])
      LibGLFW.set_window_size_limits @handle, min_width, min_height, max_width, max_height
    end

    # Alternate syntax for `#set_size_limits`.
    #
    # ```
    # # Disallow the window to be resized smaller than 100x100 or larger than 640x480.
    # limits = {min_width: 100, min_height: 100, max_width: 640, max_height: 480}
    # window.size_limits = limits
    # ```
    #
    # This method accepts the following arguments:
    # - *limits*, the desired size limits to impose on the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def size_limits=(limits : NamedTuple(min_width: Int32, min_height: Int32,
                     max_width: Int32, max_height: Int32))
      set_size_limits limits[:min_width], limits[:min_height], limits[:max_width], limits[:max_height]
    end

    # Sets the aspect ratio of the window.
    #
    # ```
    # # Sets the window's aspect ratio to 16:9.
    # window.set_aspect_ratio 16, 9
    # ```
    #
    # This method accepts the following arguments:
    # - *numerator*, the numerator of the aspect ratio.
    # - *denominator*, the denominator of the aspect ratio.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_aspect_ratio(numerator : Int32 = CrystGLFW[:dont_care], denominator : Int32 = CrystGLFW[:dont_care])
      LibGLFW.set_aspect_ratio @handle, numerator, denominator
    end

    # Alternate syntax for `#set_aspect_ratio`.
    #
    # ```
    # # Sets the window's aspect ratio to 16:9.
    # window.aspect_ratio = {numerator: 16, denominator: 9}
    # ```
    #
    # This method accepts the following arguments:
    # - *ratio*, the desired aspect ratio.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def aspect_ratio=(ratio : NamedTuple(numerator: Int32, denominator: Int32))
      set_aspect_ratio ratio[:numerator], ratio[:denominator]
    end

    # Returns the size of the framebuffer.
    #
    # ```
    # # Retrieve the framebuffer's size.
    # fb_size = window.framebuffer_size
    #
    # # Print the size of the framebuffer.
    # puts "The size of the framebuffer is #{fb_size[:width]} x #{fb_size[:height]}."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def framebuffer_size : NamedTuple(width: Int32, height: Int32)
      LibGLFW.get_framebuffer_size @handle, out width, out height
      {width: width, height: height}
    end

    # Returns the size of the window's frame at each of its edges in screen coordinates.
    #
    # ```
    # # Retrieve the size of the window's frame along the top edge.
    # title_bar_height = window.frame_size[:top]
    #
    # # Print out the title bar's height.
    # puts "This window's title bar is #{title_bar_height} screen coordinates tall."
    # ```
    #
    # Each edge of the window is accessible: left, top, right, bottom.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def frame_size : NamedTuple(left: Int32, top: Int32, right: Int32, bottom: Int32)
      LibGLFW.get_window_frame_size @handle, out left, out top, out right, out bottom
      {left: left, top: top, right: right, bottom: bottom}
    end

    # Iconifies (minimizes) the window. The exact opposite of `#restore`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def iconify
      LibGLFW.iconify_window @handle
    end

    # Restores (de-minimizes) the window. The exact opposite of `#iconify`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def restore
      LibGLFW.restore_window @handle
    end

    # Maximizes the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def maximize
      LibGLFW.maximize_window @handle
    end

    # Shows the window (makes it visible). The exact opposite of `#hide`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def show
      LibGLFW.show_window @handle
    end

    # Hides the window (makes it invisible). The exact opposite of `#show`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def hide
      LibGLFW.hide_window @handle
    end

    # Focuses the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def focus
      LibGLFW.focus_window @handle
    end

    # Returns true if the window is full screened. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def full_screen? : Bool
      monitor_handle = LibGLFW.get_window_monitor(@handle)
      !monitor_handle.nil?
    end

    # Returns the window's monitor if the window is in fullscreen mode. Returns nil otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def monitor : Monitor
      monitor_candidate = LibGLFW.get_window_monitor(@handle)
      if monitor_candidate.null?
        raise Error.generate(:not_full_screen)
      else
        Monitor.new(monitor_candidate)
      end
    end

    # Sets the monitor used for full screen mode.
    #
    # ```
    # monitor = Monitor.primary
    # unless window.full_screen?
    #   window.set_monitor monitor
    # end
    # ```
    #
    # The monitor's current video mode is used when the window is made full-screen.
    #
    # This method accepts the following arguments:
    # - *mon*, the monitor that will be used for full screen mode.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_monitor(mon : CrystGLFW::Monitor)
      video_mode = mon.video_mode
      LibGLFW.set_window_monitor @handle, mon, CrystGLFW[:dont_care], CrystGLFW[:dont_care],
        video_mode.width, video_mode.height, video_mode.refresh_rate
    end

    # Alternate syntax for `#set_monitor`
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def monitor=(mon : CrystGLFW::Monitor)
      set_monitor mon
    end

    # Exits full screen mode and enters windowed mode with the given settings.
    #
    # ```
    # if window.full_screen?
    #   # Enter windowed mode at (50, 50) with dimensions 800x600.
    #   window.exit_full_screen(x: 50, y: 50, width: 800, height: 600)
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *x*, the x-coordinate of the window's desired position.
    # - *y*, the y-coordinate of the window's desired position.
    # - *width*, the width of the window.
    # - *height*, the height of the window.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def exit_full_screen(x : Int32 = 100, y : Int32 = 100, width : Int32 = 640, height : Int32 = 480)
      LibGLFW.set_window_monitor @handle, nil, x, y, width, height, CrystGLFW[:dont_care]
    end

    # Checks to see if the given key is pressed according to this window.
    #
    # ```
    # key = event.key
    # if window.key_pressed?(key)
    #   puts "key is pressed!"
    # end
    # ```
    #
    # The key's state is affected by sticky keys.
    #
    # This method accepts the following arguments:
    # - *key*, the key to check.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def key_pressed?(key : CrystGLFW::Key)
      LibGLFW.get_key(@handle, key) == CrystGLFW[:press]
    end

    # Checks to see if the given mouse button is pressed according to this window.
    #
    # ```
    # mouse_button = event.mouse_button
    # if window.mouse_button_pressed?(mouse_button)
    #   puts "mouse button is pressed!"
    # end
    # ```
    #
    # The mouse button's state is affected by sticky mouse buttons.
    #
    # This method accepts the following arguments:
    # - *mouse_button*, the mouse button to check.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def mouse_button_pressed?(mouse_button : CrystGLFW::MouseButton)
      LibGLFW.get_mouse_button(@handle, mouse_button) == CrystGLFW[:press]
    end

    # Sets the window's icon.
    #
    # TODO: Add an example here.
    #
    # This method accepts the following arguments:
    # - *icon*, the window's desired icon image.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_icon(icon : Image)
      LibGLFW.set_window_icon @handle, 1, image
    end

    # Alternate syntax for `#set_icon`
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def icon=(icon : Image)
      set_icon icon
    end

    # Returns true if the window is focused. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def focused? : Bool
      check_attribute :focused
    end

    # Returns true if the window is iconified (minimized). False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def iconified? : Bool
      check_attribute :iconified
    end

    # Returns true if the window is maximized. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def maximized? : Bool
      check_attribute :maximized
    end

    # Returns true if the window is visible. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def visible? : Bool
      check_attribute :visible
    end

    # Returns true if the window is resizable. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def resizable? : Bool
      check_attribute :resizable
    end

    # Returns true if the window is decorated. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def decorated? : Bool
      check_attribute :decorated
    end

    # Returns true if the window is floating. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def floating? : Bool
      check_attribute :floating
    end

    # Returns the window's current cursor or creates one if it does not exist.
    #
    # ```
    # cursor = window.cursor
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor
      @@cursor_registry[@handle]? ? @@cursor_registry[@handle] : Cursor.new(:arrow_cursor, self)
    end

    # Creates a cursor for the window with the given shape.
    #
    # ```
    # # Creates a crosshair cursor
    # cursor = window.cursor :crosshair_cursor
    #
    # # Creates an ibeam cursor
    # cursor = window.cursor :ibeam_cursor
    # ```
    #
    # This method accepts the following arguments:
    # - *shape*, a symbol representing the desired shape of the cursor.
    #
    # *shape* can be one of the following values:
    # - :arrow_cursor
    # - :ibeam_cursor
    # - :crosshair_cursor
    # - :vresize_cursor
    # - :hresize_cursor
    # - :hand_cursor
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor(shape : Symbol)
      @@cursor_registry[@handle].destroy if @@cursor_registry[@handle]?
      @@cursor_registry[@handle] = Cursor.new shape, self
      @@cursor_registry[@handle]
    end

    # Creates a cursor that looks like *image* with hotspot at (*x*, *y*).
    #
    # ```
    # # Create a cursor that looks like cool_image, with hotspot at (12, 12)
    # cursor = window.cursor cool_image, 12, 12
    # ```
    #
    # This method accepts the following arguments:
    # - *image*, the desired cursor image.
    # - *x*, the x-coordinate of the cursor hotspot, relative to the top-left corner of the image..
    # - *y*, the y-coordinate of the cursor hotspot, relative to the top-left corner of the image.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor(image : Image, x : Int32, y : Int32)
      @@cursor_registry[@handle].destroy if @@cursor_registry[@handle]?
      @@cursor_registry[@handle] = Cursor.new image, x, y, self
      @@cursor_registry[@handle]
    end

    # Removes the window's current cursor.
    #
    # ```
    # window.remove_cursor if window.should_close?
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def remove_cursor
      @@cursor_registry[@handle].destroy if @@cursor_registry[@handle]?
      @@cursor_registry.delete @handle
      LibGLFW.set_cursor @handle, nil
    end

    # Returns true if the window's cursor mode is normal. False otherwise.
    #
    # ```
    # if window.cursor_normal?
    #   puts "The window's cursor mode is normal!"
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor_normal?
      CrystGLFW[:cursor_normal] == LibGLFW.get_input_mode(@handle, CrystGLFW[:cursor])
    end

    # Returns true if the window's cursor mode is hidden. False otherwise.
    #
    # ```
    # if window.cursor_hidden?
    #   puts "The window's cursor mode is hidden!"
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor_hidden?
      CrystGLFW[:cursor_hidden] == LibGLFW.get_input_mode(@handle, CrystGLFW[:cursor])
    end

    # Returns true if the window's cursor mode is disabled. False otherwise.
    #
    # ```
    # if window.cursor_disabled?
    #   puts "The window's cursor mode is disabled!"
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def cursor_disabled?
      CrystGLFW[:cursor_disable] == LibGLFW.get_input_mode(@handle, CrystGLFW[:cursor])
    end

    # Sets the cursor mode to normal.
    #
    # ```
    # window.normalize_cursor
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def normalize_cursor
      LibGLFW.set_input_mode @handle, CrystGLFW[:cursor], CrystGLFW[:cursor_normal]
    end

    # Sets the cursor mode to hidden.
    #
    # ```
    # window.hide_cursor
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def hide_cursor
      LibGLFW.set_input_mode @handle, CrystGLFW[:cursor], CrystGLFW[:cursor_hidden]
    end

    # Sets the cursor mode to disabled.
    #
    # ```
    # window.disable_cursor
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def disable_cursor
      LibGLFW.set_input_mode @handle, CrystGLFW[:cursor], CrystGLFW[:cursor_disable]
    end

    # Returns true if sticky keys are enabled. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def sticky_keys? : Bool
      value = LibGLFW.get_input_mode @handle, CrystGLFW[:sticky_keys]
      value == CrystGLFW[:true]
    end

    # Enables sticky keys.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def enable_sticky_keys
      LibGLFW.set_input_mode @handle, CrystGLFW[:sticky_keys], CrystGLFW[:true]
    end

    # Disables sticky keys.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def disable_sticky_keys
      LibGLFW.set_input_mode @handle, CrystGLFW[:sticky_keys], CrystGLFW[:false]
    end

    # Returns true if sticky mouse buttons are enabled. False otherwise.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def sticky_mouse_buttons? : Bool
      value = LibGLFW.get_input_mode @handle, CrystGLFW[:sticky_mouse_buttons]
      value == CrystGLFW[:true]
    end

    # Enables sticky mouse buttons.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def enable_sticky_mouse_buttons
      LibGLFW.set_input_mode @handle, CrystGLFW[:sticky_mouse_buttons], CrystGLFW[:true]
    end

    # Disables sticky mouse buttons.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def disable_sticky_mouse_buttons
      LibGLFW.set_input_mode @handle, CrystGLFW[:sticky_mouse_buttons], CrystGLFW[:false]
    end

    # Returns the contents of the system clipboard as a String.
    #
    # ```
    # puts window.clipboard # Prints the contents of the clipboard.
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def clipboard : String
      String.new(LibGLFW.get_clipboard_string(@handle))
    end

    # Sets the contents of the system clipboard.
    #
    # ```
    # window.set_clipboard "Hello from GLFW!"
    # ```
    #
    # This method accepts the following arguments:
    # - *clipboard_string*, the desired contents of the clipboard.
    def set_clipboard(clipboard_string : String)
      LibGLFW.set_clipboard_string @handle, clipboard_string
    end

    # Alternate syntax for `#set_clipboard`.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def clipboard=(clipboard_string : String)
      LibGLFW.set_clipboard_string @handle, clipboard_string
    end

    # Sets the window to be the current OpenGL context.
    #
    # ```
    # window = Window.new(title: "Awesome window")
    # window.make_context_current
    # until window.should_close?
    #   window.wait_events
    #   window.swap_buffers
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def make_context_current
      LibGLFW.make_context_current @handle
    end

    # Swaps the front and back buffers.
    #
    # ```
    # window = Window.new(title: "Awesome window")
    # window.make_context_current
    # until window.should_close?
    #   window.wait_events
    #   window.swap_buffers
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def swap_buffers
      LibGLFW.swap_buffers @handle
    end

    # :nodoc:
    def ==(other : Window) : Bool
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe : Pointer(LibGLFW::Window)
      @handle
    end

    # Checks a window attribute by label.
    private def check_attribute(attribute_label : Symbol) : Bool
      value = LibGLFW.get_window_attrib @handle, CrystGLFW[attribute_label]
      value == CrystGLFW[:true]
    end

    # Sets the immutable move callback shim.
    private def set_move_callback
      callback = LibGLFW::Windowposfun.new do |handle, x, y|
        win = Window.new(handle)
        event = Event::WindowMove.new(win, x, y)
        @@callback_registry[handle][:move].as(MoveCallback).try &.call(event)
      end
      LibGLFW.set_window_pos_callback @handle, callback
    end

    # Sets the immutable resize callback shim.
    private def set_resize_callback
      callback = LibGLFW::Windowsizefun.new do |handle, width, height|
        win = Window.new(handle)
        event = Event::WindowResize.new(win, width, height)
        @@callback_registry[handle][:resize].as(ResizeCallback).try &.call(event)
      end
      LibGLFW.set_window_size_callback @handle, callback
    end

    # Sets the immutable close callback shim.
    private def set_close_callback
      callback = LibGLFW::Windowclosefun.new do |handle|
        win = Window.new(handle)
        event = Event::WindowClose.new(win)
        @@callback_registry[handle][:close].as(CloseCallback).try &.call(event)
      end
      LibGLFW.set_window_close_callback @handle, callback
    end

    # Sets the immutable refresh callback shim.
    private def set_refresh_callback
      callback = LibGLFW::Windowrefreshfun.new do |handle|
        win = Window.new(handle)
        event = Event::WindowRefresh.new(win)
        @@callback_registry[handle][:refresh].as(RefreshCallback).try &.call(event)
      end
      LibGLFW.set_window_refresh_callback @handle, callback
    end

    # Sets the immutable toggle focus callback shim.
    private def set_toggle_focus_callback
      callback = LibGLFW::Windowfocusfun.new do |handle, focused_code|
        win = Window.new(handle)
        focused? = focused_code == CrystGLFW[:true]
        event = Event::WindowToggleFocus.new(win, focused?)
        @@callback_registry[handle][:toggle_focus].as(ToggleFocusCallback).try &.call(event)
      end
      LibGLFW.set_window_focus_callback @handle, callback
    end

    # Sets the immutable toggle iconification callback shim.
    private def set_toggle_iconification_callback
      callback = LibGLFW::Windowiconifyfun.new do |handle, iconified_code|
        win = Window.new(handle)
        iconified? = iconified_code == CrystGLFW[:true]
        event = Event::WindowToggleIconification.new(win, iconified?)
        @@callback_registry[handle][:toggle_iconification].as(ToggleIconificationCallback).try &.call(event)
      end
      LibGLFW.set_window_iconify_callback @handle, callback
    end

    # Sets the immutable framebuffer resize callback shim.
    private def set_framebuffer_resize_callback
      callback = LibGLFW::Framebuffersizefun.new do |handle, width, height|
        win = Window.new(handle)
        event = Event::WindowFramebufferResize.new(win, width, height)
        @@callback_registry[handle][:framebuffer_resize].as(FramebufferResizeCallback).try &.call(event)
      end
      LibGLFW.set_framebuffer_size_callback @handle, callback
    end

    # Sets the immutable key callback shim.
    private def set_key_callback
      callback = LibGLFW::Keyfun.new do |handle, key_code, scancode, action, modifiers|
        win = Window.new(handle)
        key = Key.new(key_code, scancode)
        event = Event::WindowKey.new(win, key, action, modifiers)
        @@callback_registry[handle][:key].as(KeyCallback).try &.call(event)
      end
      LibGLFW.set_key_callback @handle, callback
    end

    # Sets the immutable character callback shim.
    private def set_char_callback
      callback = LibGLFW::Charmodsfun.new do |handle, char, modifiers|
        win = Window.new(handle)
        event = Event::WindowChar.new(win, char.chr, modifiers)
        @@callback_registry[handle][:char].as(CharCallback).try &.call(event)
      end
      LibGLFW.set_char_mods_callback @handle, callback
    end

    # Sets the immutable mouse button callback shim.
    private def set_mouse_button_callback
      callback = LibGLFW::Mousebuttonfun.new do |handle, button, action, modifiers|
        win = Window.new(handle)
        mouse_button = MouseButton.new(button)
        event = Event::WindowMouseButton.new(win, mouse_buton, action, modifiers)
        @@callback_registry[handle][:mouse_button].as(MouseButtonCallback).try &.call(event)
      end
      LibGLFW.set_mouse_button_callback @handle, callback
    end

    # Sets the immutable scroll callback shim.
    private def set_scroll_callback
      callback = LibGLFW::Scrollfun.new do |handle, x, y|
        win = Window.new(handle)
        event = Event::WindowScroll.new(win, x, y)
        @@callback_registry[handle][:scroll].as(ScrollCallback).try &.call(event)
      end
      LibGLFW.set_scroll_callback @handle, callback
    end

    # Sets the immutable cursor cross threshold callback shim.
    private def set_cursor_cross_threshold_callback
      callback = LibGLFW::Cursorenterfun.new do |handle, entered_code|
        win = Window.new(handle)
        cursor = win.cursor
        entered = entered_code == CrystGLFW[:true]
        event = Event::WindowCursorCrossThreshold.new(win, cursor, entered)
        @@callback_registry[handle][:cursor_cross_threshold].as(CursorCrossThresholdCallback).try &.call(event)
      end
      LibGLFW.set_cursor_enter_callback @handle, callback
    end

    # Sets the immutable cursor move callback shim.
    private def set_cursor_move_callback
      callback = LibGLFW::Cursorposfun.new do |handle, x, y|
        win = Window.new(handle)
        cursor = win.cursor
        event = Event::WindowCursorMove.new(win, cursor, x, y)
        @@callback_registry[handle][:cursor_move].as(CursorMoveCallback).try &.call(event)
      end
      LibGLFW.set_cursor_pos_callback @handle, callback
    end

    # Sets the immutable file drop callback shim.
    private def set_file_drop_callback
      callback = LibGLFW::Dropfun.new do |handle, count, raw_paths|
        win = Window.new(handle)
        paths = count.times.map { |i| String.new(raw_paths[i]) }
        event = Event::WindowFileDrop.new(win, paths.to_a)
        @@callback_registry[handle][:file_drop].as(FileDropCallback).try &.call(event)
      end
      LibGLFW.set_drop_callback @handle, callback
    end

    # Initializes the callback registry.
    private def initialize_callbacks
      @@callback_registry[@handle] = Hash(Symbol, WindowCallback).new
    end

    # Defines all of the callback methods.
    macro define_callbacks(pairs)
    {% for symbol, camel in pairs %}
      define_callback({{symbol}}, {{camel}})
    {% end %}
    end

    # Defines a callback method.
    macro define_callback(symbol, camel)
    def on_{{symbol.id}}(&callback : {{camel}}Callback)
      set_{{symbol.id}}_callback unless @@callback_registry[@handle][{{symbol}}]?
      @@callback_registry[@handle][{{symbol}}] = callback
    end
    end

    # Call the define_callbacks macro.
    define_callbacks({
      :move                   => Move,
      :resize                 => Resize,
      :close                  => Close,
      :refresh                => Refresh,
      :toggle_focus           => ToggleFocus,
      :toggle_iconification   => ToggleIconification,
      :framebuffer_resize     => FramebufferResize,
      :key                    => Key,
      :char                   => Char,
      :mouse_button           => MouseButton,
      :scroll                 => Scroll,
      :cursor_cross_threshold => CursorCrossThreshold,
      :cursor_move            => CursorMove,
      :file_drop              => FileDrop,
    })
  end
end
