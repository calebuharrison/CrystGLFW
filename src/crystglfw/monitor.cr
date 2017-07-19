require "lib_glfw"

module CrystGLFW
  struct Monitor
    alias ConnectionChangeCallback = Proc(Symbol, Nil)
    alias MonitorCallback = ConnectionChangeCallback | Nil

    @@callback_registry = {} of Pointer(LibGLFW::Monitor) => MonitorCallback

    private def initialize(handle : Pointer(LibGLFW::Monitor))
      @handle = handle
    end

    def self.all
      handles = LibGLFW.get_monitors(out count)
      monitors = count.times.map { |i| new(handles[i]) }
      monitors.to_a
    end

    def self.primary
      new(LibGLFW.get_primary_monitor)
    end

    def on_connection_change(&callback : ConnectionChangeCallback)
      set_connection_change_callback unless @@callback_registry[@handle]?
      @@callback_registry[@handle] = callback
    end

    def position
      LibGLFW.get_monitor_pos(@handle, out x, out y)
      {x: x, y: y}
    end

    def physical_size
      LibGLFW.get_monitor_physical_size(@handle, out width, out height)
      {width: width, height: height}
    end

    def name
      String.new(LibGLFW.get_monitor_name(@handle))
    end

    def video_modes
      vid_modes = LibGLFW.get_video_modes(@handle, out count)
      video_modes = count.times.map { |i| VideoMode.new(vid_modes[i]) }
      video_modes.to_a
    end

    def video_mode
      VideoMode.new LibGLFW.get_video_mode(@handle)
    end

    def gamma=(gamma : Float32)
      LibGLFW.set_gamma @handle, gamma
    end

    def gamma_ramp
      GammaRamp.new LibGLFW.get_gamma_ramp(@handle)
    end

    def gamma_ramp=(gamma_ramp : GammaRamp)
      LibGLFW.set_gamma_ramp @handle, gamma_ramp
    end

    def ==(other : Monitor)
      @handle == other.to_unsafe
    end

    def to_unsafe
      @handle
    end

    private def set_connection_change_callback
      callback = LibGLFW::Monitorfun.new do |handle, event|
        @@callback_registry[handle].as(ConnectionChangeCallback).try &.call(event)
      end
      LibGLFW.set_monitor_callback callback
    end
  end
end
