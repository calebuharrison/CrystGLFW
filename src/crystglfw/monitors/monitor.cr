require "lib_glfw"

module CrystGLFW
  # A Monitor represents a physical monitor connected to the system.
  struct Monitor
    alias ToggleConnectionCallback = Proc(Event::MonitorToggleConnection, Nil)
    alias MonitorCallback = ToggleConnectionCallback | Nil

    @@monitor_callback : MonitorCallback

    # Sets the immutable monitor connection callback shim.
    private def self.set_toggle_connection_callback
      callback = LibGLFW::Monitorfun.new do |handle, connection_code|
        monitor = new(handle)
        connection_status = ConnectionStatus.new(connection_code)
        event = Event::MonitorToggleConnection.new(monitor, connection_status)
        @@monitor_callback.try &.call(event)
      end
      LibGLFW.set_monitor_callback callback
    end

    # Defines the behavior that gets triggered when a monitor is either connected or disconnected.
    #
    # ```
    # monitor = CrystGLFW::Monitor.primary
    # monitor.on_toggle_connection do |event|
    #   if event.connected?
    #     puts "Welcome back, #{event.monitor.name}!"
    #   else
    #     puts "Farewell, #{event.monitor.name}."
    #   end
    # end
    # ```
    def self.on_toggle_connection(&callback : ToggleConnectionCallback)
      @@monitor_callback = callback
    end

    # Returns all monitors currently connected to the system as an Array.
    #
    # ```
    # monitors = CrystGLFW::Monitor.all
    # monitors.each { |m| puts m.name } # Prints out the name of each connected monitor.
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.all : Array(Monitor)
      handles = LibGLFW.get_monitors(out count)
      count.times.map { |i| Monitor.new(handles[i]) }
    end

    # Returns the primary monitor, which is inferred by GLFW as the window that includes the task bar.
    #
    # ```
    # monitor = CrystGLFW::Monitor.primary
    # puts "Monitor #{monitor.name} is the primary monitor."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.primary : Monitor
      new(LibGLFW.get_primary_monitor)
    end

    private def initialize(handle : Pointer(LibGLFW::Monitor))
      @handle = handle
    end

    # Returns the position of the upper-left corner of the monitor in screen coordinates relative to the virtual screen.
    #
    # ```
    # # Retrieve all monitors.
    # monitors = CrystGLFW::Monitors.all
    #
    # # Find the monitor that is furthest to the left.
    # leftmost_monitor = monitors.min_by { |monitor| monitor.position[:x] }
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position : NamedTuple(x: Int32, y: Int32)
      LibGLFW.get_monitor_pos(@handle, out x, out y)
      { x: x, y: y }
    end

    # Returns the physical size of the monitor in millimeters.
    #
    # ```
    # # Retrieve the primary monitor.
    # monitor = CrystGLFW::Monitor.primary
    #
    # # Calculate the area of the monitor using its physical size.
    # monitor_area = monitor.physical_size[:width] * monitor.physical_size[:height]
    #
    # # Print the area of the monitor in millimeters.
    # puts "The area of the monitor is #{monitor_area} millimeters squared."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def physical_size : NamedTuple(width: Int32, height: Int32)
      LibGLFW.get_monitor_physical_size(@handle, out width, out height)
      { width: width, height: height }
    end

    # Returns the monitor's name, as set by the manufacturer.
    #
    # ```
    # # Retrieve the primary monitor.
    # monitor = CrystGLFW::Monitor.primary
    #
    # # Print out the name of the monitor.
    # puts "The name of the primary monitor is #{monitor.name}"
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def name : String
      String.new LibGLFW.get_monitor_name(@handle)
    end

    # Returns the monitor's supported video modes.
    #
    # TODO: Add an example here.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def video_modes : Array(VideoMode)
      vid_modes = LibGLFW.get_video_modes(@handle, out count)
      count.times.map { |i| VideoMode.new(vid_modes + i) }
    end

    # Returns the monitor's current video mode.
    #
    # ```
    # # Retrieve the primary monitor.
    # monitor = CrystGLFW::Monitor.primary
    #
    # current_video_mode = monitor.video_mode
    # ```
    #
    # TODO: Improve this example with something useful.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def video_mode : VideoMode
      VideoMode.new LibGLFW.get_video_mode(@handle)
    end

    # Generates a gamma ramp from the given exponent and sets it as the monitor's gamma ramp.
    #
    # This method accepts the following arguments:
    # - *gamma*, the exponent used to generate the new gamma ramp.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def set_gamma(gamma : Number)
      LibGLFW.set_gamma @handle, gamma
    end

    # Alternate syntax for `#set_gamma`.
    #
    # This method accepts the following arguments:
    # - *gamma*, the exponent used to generate the new gamma ramp.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def gamma=(gamma : Number)
      LibGLFW.set_gamma @handle, gamma
    end

    # Returns the monitor's current gamma ramp.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def gamma_ramp : GammaRamp
      GammaRamp.new LibGLFW.get_gamma_ramp(@handle)
    end

    # Sets the monitor's gamma ramp to the given gamma ramp.
    def set_gamma_ramp(gamma_ramp : GammaRamp)
      LibGLFW.set_gamma_ramp @handle, gamma_ramp
    end

    # Alternate syntax for `#set_gamma_ramp`.
    def gamma_ramp=(gamma_ramp : GammaRamp)
      LibGLFW.set_gamma_ramp @handle, gamma_ramp
    end

    # :nodoc:
    def ==(other : Monitor)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe : Pointer(LibGLFW::Monitor)
      @handle
    end

    set_toggle_connection_callback
  end
end
