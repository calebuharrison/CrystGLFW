require "LibGLFW"

module CrystGLFW
  include LibGLFW

class Window

  def initialize(@handle)
  end

  def initialize(width = 640, height = 480, title = "", monitor = nil, sharing_window = nil)
    @handle = LibGLFW.create_window(width, height, title, monitor, sharing_window)
  end

  def destroy
    LibGLFW.destroy_window(@handle)
    @handle = nil
  end

  def should_close
    LibGLFW.window_should_close(@handle) != 0
  end

  def should_close?
    LibGLFW.window_should_close(@handle) != 0
  end

  def should_close=(flag : Bool)
    value = flag ? 1 : 0
    LibGLFW.set_window_should_close(@handle, value)
  end

  def title=(title : String)
    LibGLFW.set_window_title(@handle, title)
  end

  def position
    LibGLFW.get_window_pos(@handle, out x, out y)
    { x: x, y: y }
  end

  def position=(x, y)
    LibGLFW.set_window_pos(@handle, x, y)
  end

  def size
    LibGLFW.get_window_size(@handle, out width, out height)
    { width: width, height: height }
  end

  def size=(width, height)
    LibGLFW.set_window_size(@handle, width, height)
  end

  def size_limits=(min_width = LibGLFW::DONT_CARE, min_height = LibGLFW::DONT_CARE,
                   max_width = LibGLFW::DONT_CARE, max_height = LibGLFW::DONT_CARE)
    LibGLFW.set_window_size_limits(@handle, min_width, min_height, max_width, max_height)
  end

  def aspect_ratio=(numerator = LibGLFW::DONT_CARE, denominator = LibGLFW::DONT_CARE)
    LibGLFW.set_window_aspect_ratio(@handle, numerator, denominator)
  end

  def framebuffer_size
    LibGLFW.get_framebuffer_size(@handle, out width, out height)
    { width: width, height: height }
  end

  def frame_size
    LibGLFW.get_window_frame_size(@handle, out left, out top, out right, out bottom)
    { left: left, top: top, right: right, bottom: bottom }
  end

  def iconify
    LibGLFW.iconify_window(@handle)
  end

  def restore
    LibGLFW.restore_window(@handle)
  end

  def maximize
    LibGLFW.maximize_window(@handle)
  end

  def show
    LibGLFW.show_window(@handle)
  end

  def hide
    LibGLFW.hide_window(@handle)
  end

  def focus
    LibGLFW.focus_window(@handle)
  end

  def monitor
    monitor_handle = LibGLFW.get_window_monitor(@handle)
    Monitor.new(monitor_handle)
  end

  def focused?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::FOCUSED) 
    value != 0
  end

  def iconified?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::ICONIFIED)
    value != 0
  end

  def maximized?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::MAXIMIZED)
    value != 0
  end

  def visible?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::VISIBLE)
    value != 0
  end

  def resizable?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::RESIZABLE)
    value != 0
  end

  def decorated?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::DECORATED)
    value != 0
  end

  def floating?
    value = LibGLFW.get_window_attrib(@handle, LibGLFW::FLOATING)
    value != 0
  end

  def become_current_context
    LibGLFW.make_context_current(@handle)
  end

  def swap_buffers
    LibGLFW.swap_buffers(@handle)
  end

  def to_unsafe
    @handle
  end

end

end
