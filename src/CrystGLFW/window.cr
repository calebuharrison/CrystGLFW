require "lib_glfw"

module CrystGLFW
  # A Window represents a GLFW Window and its associated OpenGL context.
  struct Window
    alias MoveCallback = Proc(Int32, Int32, Nil)
    alias ResizeCallback = Proc(Int32, Int32, Nil)
    alias CloseCallback = Proc(Nil)
    alias RefreshCallback = Proc(Nil)
    alias ToggleFocusCallback = Proc(Nil)
    alias ToggleIconificationCallback = Proc(Nil)
    alias FramebufferResizeCallback = Proc(Int32, Int32, Nil)
    alias KeyCallback = Proc(KeyEvent, Nil)
    alias CharCallback = Proc(CharEvent, Nil)
    alias MouseButtonCallback = Proc(MouseButtonEvent, Nil)
    alias ScrollCallback = Proc(Float64, Float64, Nil)
    alias CursorCrossThresholdCallback = Proc(Nil)
    alias CursorMoveCallback = Proc(Float64, Float64, Nil)
    alias FileDropCallback = Proc(Array(String), Nil)

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

    # Returns the window whose context is current.
    #
    # ```
    # current_window = CrystGLFW::Window.current
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.current
      new(LibGLFW.get_current_context)
    end

    # :nodoc:
    def self.set_hints(hints : Hash(Symbol, Int32 | Symbol))
      hints.each do |key, value|
        hint_value = value.is_a?(Symbol) ? CrystGLFW[value] : value
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
    # - *sharing_window*, the window whose context to share resource with. If left blank, no resource sharing occurs.
    # - *hints*, the desired window options. If left blank, GLFW defaults will be used.
    #
    # There are several different kinds of hints that can be set, all of which can be found in the GLFW documentation.
    # To specify hints for window creation, create a hash:
    #
    # ```
    # hints = { :client_api => :opengl_es_api, :context_version_major => 3 }
    # window = CrystGLFW::Window.new(title: "My Window", monitor: CrystGLFW::Monitor.primary, hints: hints)
    # ```
    #
    # Hints are cleared after window creation, so they are only used when passed.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def initialize(width = 640, height = 480, title = "", monitor = nil, sharing_window = nil, hints = nil)
      Window.set_hints(hints) if hints
      @handle = LibGLFW.create_window width, height, title, monitor, sharing_window
      Window.clear_hints if hints
      initialize_callbacks unless @@callback_registry[@handle]?
    end

    # :nodoc:
    def initialize(handle : Pointer(LibGLFW::Window))
      @handle = handle
      initialize_callbacks unless @@callback_registry[@handle]?
    end

    # Destroys the underlying GLFW Window and removes it from the callback registry.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def destroy
      LibGLFW.destroy_window @handle
      @@callback_registry.delete @handle
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
    def should_close?
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
      LibGLFW.set_window_should_close @handle, CrystGLFW.constants[:true]
    end

    # The exact opposite of `#should_close`
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def should_not_close
      LibGLFW.set_window_should_close @handle, CrystGLFW.constants[:false]
    end

    # Sets the window's title.
    #
    # ```
    # window.on_key |key_event|
    #   # If the key is printable, then set the window title to the name of the key.
    #   window.title = key_event.key.name if key_event.key.printable? && key_event.press?
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def title=(title : String)
      LibGLFW.set_window_title @handle, title
    end

    def position
      LibGLFW.get_window_pos @handle, out x, out y
      {x: x, y: y}
    end

    def position=(x : Int32, y : Int32)
      LibGLFW.set_window_pos @handle, x, y
    end

    def size
      LibGLFW.get_window_size @handle, out width, out height
      {width: width, height: height}
    end

    def size=(width : Int32, height : Int32)
      LibGLFW.set_window_size @handle, width, height
    end

    def edges
      p = position
      s = size
      x = (p[:x]..(p[:x] + s[:width]))
      y = (p[:y]..(p[:y] + s[:height]))
      {x: x, y: y}
    end

    def contains?(x : Number, y : Number)
      e = edges
      e[:x].includes?(x) && e[:y].includes?(y)
    end

    def size_limits=(min_width = CrystGLFW.constants[:dont_care], min_height = CrystGLFW.constants[:dont_care],
                     max_width = CrystGLFW.constants[:dont_care], max_height = CrystGLFW.constants[:dont_care])
      LibGLFW.set_window_size_limits @handle, min_width, min_height, max_width, max_height
    end

    def aspect_ratio=(numerator = CrystGLFW.constants[:dont_care], denominator = CrystGLFW.constants[:dont_care])
      LibGLFW.set_window_aspect_ratio @handle, numerator, denominator
    end

    def framebuffer_size
      LibGLFW.get_framebuffer_size @handle, out width, out height
      {width: width, height: height}
    end

    def frame_size
      LibGLFW.get_window_frame_size @handle, out left, out top, out right, out bottom
      {left: left, top: top, right: right, bottom: bottom}
    end

    def iconify
      LibGLFW.iconify_window @handle
    end

    def restore
      LibGLFW.restore_window @handle
    end

    def maximize
      LibGLFW.maximize_window @handle
    end

    def show
      LibGLFW.show_window @handle
    end

    def hide
      LibGLFW.hide_window @handle
    end

    def focus
      LibGLFW.focus_window @handle
    end

    def monitor
      Monitor.new(LibGLFW.get_window_monitor(@handle))
    end

    def monitor=(monitor, x, y, width, height, refresh_rate = CrystGLFW.constants[:dont_care])
      LibGLFW.set_window_monitor @handle, monitor, x, y, width, height, refresh_rate
    end

    def icon=(icon : Image)
      LibGLFW.set_window_icon @handle, 1, image
    end

    def focused?
      check_attribute :focused
    end

    def iconified?
      check_attribute :iconified
    end

    def maximized?
      check_attribute :maximized
    end

    def visible?
      check_attribute :visible
    end

    def resizable?
      check_attribute :resizable
    end

    def decorated?
      check_attribute :decorated
    end

    def floating?
      check_attribute :floating
    end

    def cursor=(new_cursor : Cursor)
      LibGLFW.set_cursor @handle, new_cursor
    end

    def remove_cursor
      LibGLFW.set_cursor @handle, nil
    end

    def cursor_position
      LibGLFW.get_cursor_pos @handle, out x, out y
      {x: x, y: y}
    end

    def cursor_position=(x : Float64, y : Float64)
      LibGLFW.set_cursor_pos @handle, x, y
    end

    def cursor_mode
      value = LibGLFW.get_input_mode @handle, CrystGLFW.constants[:cursor]
      [:cursor_normal, :cursor_hidden, :cursor_disable].find { |option| CrystGLFW.constants[option] == value }
    end

    def set_cursor_mode(new_cursor_mode : Symbol)
      LibGLFW.set_input_mode @handle, CrystGLFW.constants[:cursor], CrystGLFW.constants[new_cursor_mode]
    end

    def sticky_keys?
      value = LibGLFW.get_input_mode @handle, CrystGLFW.constants[:sticky_keys]
      value == CrystGLFW.constants[:true]
    end

    def enable_sticky_keys
      LibGLFW.set_input_mode @handle, CrystGLFW.constants[:sticky_keys], CrystGLFW.constants[:true]
    end

    def disable_sticky_keys
      LibGLFW.set_input_mode @handle, CrystGLFW.constants[:sticky_keys], CrystGLFW.constants[:false]
    end

    def sticky_mouse_buttons?
      value = LibGLFW.get_input_mode @handle, CrystGLFW.constants[:sticky_mouse_buttons]
      value == CrystGLFW.constants[:true]
    end

    def enable_sticky_mouse_buttons
      LibGLFW.set_input_mode @handle, CrystGLFW.constants[:sticky_mouse_buttons], CrystGLFW.constants[:true]
    end

    def disable_sticky_mouse_buttons
      LibGLFW.set_input_mode @handle, CrystGLFW.constants[:sticky_mouse_buttons], CrystGLFW.constants[:false]
    end

    def clipboard_string
      LibGLFW.get_clipboard_string @handle
    end

    def clipboard_string=(clipboard_string : String)
      LibGLFW.set_clipboard_string @handle, clipboard_string
    end

    def make_context_current
      LibGLFW.make_context_current @handle
    end

    def swap_buffers
      LibGLFW.swap_buffers @handle
    end

    # :nodoc:
    def ==(other : Window)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end

    # Checks a window attribute by label.
    private def check_attribute(attribute_label : Symbol)
      value = LibGLFW.get_window_attrib @handle, CrystGLFW[attribute_label]
      value == CrystGLFW[:true]
    end

    # Sets the immutable move callback shim.
    private def set_move_callback
      callback = LibGLFW::Windowposfun.new do |handle, x, y|
        @@callback_registry[handle][:move].as(MoveCallback).try &.call(x, y)
      end
      LibGLFW.set_window_pos_callback @handle, callback
    end

    # Sets the immutable resize callback shim.
    private def set_resize_callback
      callback = LibGLFW::Windowsizefun.new do |handle, width, height|
        @@callback_registry[handle][:resize].as(ResizeCallback).try &.call(width, height)
      end
      LibGLFW.set_window_size_callback @handle, callback
    end

    # Sets the immutable close callback shim.
    private def set_close_callback
      callback = LibGLFW::Windowclosefun.new do |handle|
        @@callback_registry[handle][:close].as(CloseCallback).try &.call
      end
      LibGLFW.set_window_close_callback @handle, callback
    end

    # Sets the immutable refresh callback shim.
    private def set_refresh_callback
      callback = LibGLFW::Windowrefreshfun.new do |handle|
        @@callback_registry[handle][:refresh].as(RefreshCallback).try &.call
      end
      LibGLFW.set_window_refresh_callback @handle, callback
    end

    # Sets the immutable toggle focus callback shim.
    private def set_toggle_focus_callback
      callback = LibGLFW::Windowfocusfun.new do |handle, focused?|
        @@callback_registry[handle][:toggle_focus].as(ToggleFocusCallback).try &.call
      end
      LibGLFW.set_window_focus_callback @handle, callback
    end

    # Sets the immutable toggle iconification callback shim.
    private def set_toggle_iconification_callback
      callback = LibGLFW::Windowiconifyfun.new do |handle, iconified?|
        @@callback_registry[handle][:toggle_iconification].as(ToggleIconificationCallback).try &.call
      end
      LibGLFW.set_window_iconify_callback @handle, callback
    end

    # Sets the immutable framebuffer resize callback shim.
    private def set_framebuffer_resize_callback
      callback = LibGLFW::Framebuffersizefun.new do |handle, width, height|
        @@callback_registry[handle][:framebuffer_resize].as(FramebufferResizeCallback).try &.call(width, height)
      end
      LibGLFW.set_framebuffer_size_callback @handle, callback
    end

    # Sets the immutable key callback shim.
    private def set_key_callback
      callback = LibGLFW::Keyfun.new do |handle, key_code, scancode, action, modifiers|
        key_event = KeyEvent.new(Key.new(key_code, scancode), action, modifiers)
        @@callback_registry[handle][:key].as(KeyCallback).try &.call(key_event)
      end
      LibGLFW.set_key_callback @handle, callback
    end

    # Sets the immutable character callback shim.
    private def set_char_callback
      callback = LibGLFW::Charmodsfun.new do |handle, char, modifiers|
        char_event = CharEvent.new(char.chr, modifiers)
        @@callback_registry[handle][:char].as(CharCallback).try &.call(char_event)
      end
      LibGLFW.set_char_mods_callback @handle, callback
    end

    # Sets the immutable mouse button callback shim.
    private def set_mouse_button_callback
      callback = LibGLFW::Mousebuttonfun.new do |handle, button, action, modifiers|
        mouse_button_event = MouseButtonEvent.new(MouseButton.new(button), action, modifiers)
        @@callback_registry[handle][:mouse_button].as(MouseButtonCallback).try &.call(mouse_button_event)
      end
      LibGLFW.set_mouse_button_callback @handle, callback
    end

    # Sets the immutable scroll callback shim.
    private def set_scroll_callback
      callback = LibGLFW::Scrollfun.new do |handle, x, y|
        @@callback_registry[handle][:scroll].as(ScrollCallback).try &.call(x, y)
      end
      LibGLFW.set_scroll_callback @handle, callback
    end

    # Sets the immutable cursor cross threshold callback shim.
    private def set_cursor_cross_threshold_callback
      callback = LibGLFW::Cursorenterfun.new do |handle, entered?|
        @@callback_registry[handle][:cursor_cross_threshold].as(CursorCrossThresholdCallback).try &.call
      end
      LibGLFW.set_cursor_enter_callback @handle, callback
    end

    # Sets the immutable cursor move callback shim.
    private def set_cursor_move_callback
      callback = LibGLFW::Cursorposfun.new do |handle, x, y|
        @@callback_registry[handle][:cursor_move].as(CursorMoveCallback).try &.call(x, y)
      end
      LibGLFW.set_cursor_pos_callback @handle, callback
    end

    # Sets the immutable file drop callback shim.
    private def set_file_drop_callback
      callback = LibGLFW::Dropfun.new do |handle, count, raw_paths|
        paths = count.times.map { |i| String.new(raw_paths[i]) }
        @@callback_registry[handle][:file_drop].as(FileDropCallback).try &.call(paths.to_a)
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
