require "lib_glfw"

module CrystGLFW
  # A Monitor represents a physical monitor connected to the system.
  struct Monitor
    alias ConnectionChangeCallback = Proc(Symbol, Nil)
    alias MonitorCallback = ConnectionChangeCallback | Nil

    # A callback registry that maps a unique LibGLFW Monitor pointer to a callback.
    # This allows multiple monitor objects to reference the same physical monitor and
    # define universal callbacks for it.
    @@callback_registry = {} of Pointer(LibGLFW::Monitor) => MonitorCallback

    private def initialize(handle : Pointer(LibGLFW::Monitor))
      @handle = handle
    end

    # Returns all monitors currently connected to the system as an Array.
    #
    # ```
    # monitors = CrystGLFW::Monitor.all
    # monitors.each {|m| puts m.name} # Prints out the name of each connected monitor.
    # ```
    # 
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.all
      handles = LibGLFW.get_monitors(out count)
      monitors = count.times.map { |i| new(handles[i]) }
      monitors.to_a
    end

    # Returns the primary monitor, which is inferred by GLFW as the window that includes the task bar.
    #
    # ```
    # monitor = CrystGLFW::Monitor.primary
    # puts "Monitor #{monitor.name} is the primary monitor."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def self.primary
      new(LibGLFW.get_primary_monitor)
    end

    # Defines the behavior that gets triggered when a monitor is either connected or disconnected.
    #
    # ```
    # monitor = CrystGLFW::Monitor.primary
    # monitor.on_connection_change do |event|
    #   if event == :connected
    #     puts "Welcome back, #{monitor.name}!"
    #   else
    #     puts "Farewell, #{monitor.name}."
    #   end
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def on_connection_change(&callback : ConnectionChangeCallback)
      set_connection_change_callback unless @@callback_registry[@handle]?
      @@callback_registry[@handle] = callback
    end

    # Returns the position of the upper-left corner of the monitor in screen coordinates relative to the virtual screen.
    #
    # ```
    # # Retrieve all monitors.
    # monitors = CrystGLFW::Monitors.all
    #
    # # Find the monitor that is furthest to the left.
    # leftmost_monitor = monitors.min_by {|monitor| monitor.position[:x]}
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position
      LibGLFW.get_monitor_pos(@handle, out x, out y)
      {x: x, y: y}
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
    def physical_size
      LibGLFW.get_monitor_physical_size(@handle, out width, out height)
      {width: width, height: height}
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
    def name
      String.new LibGLFW.get_monitor_name(@handle)
    end

    # Returns the monitor's supported video modes.
    #
    # TODO: Add an example here.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def video_modes
      vid_modes = LibGLFW.get_video_modes(@handle, out count)
      video_modes = count.times.map { |i| VideoMode.new(vid_modes[i]) }
      video_modes.to_a
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
    def video_mode
      VideoMode.new LibGLFW.get_video_mode(@handle)
    end

    # Generates a gamma ramp from the given exponent and sets it as the monitor's gamma ramp.
    #
    # This method accepts the following arguments:
    # - *gamma*, the exponent used to generate the new gamma ramp.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def gamma=(gamma : Float32)
      LibGLFW.set_gamma @handle, gamma
    end

    # Returns the monitor's current gamma ramp.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def gamma_ramp
      GammaRamp.new LibGLFW.get_gamma_ramp(@handle)
    end

    # Sets the monitor's gamma ramp to the given gamma ramp.
    def gamma_ramp=(gamma_ramp : GammaRamp)
      LibGLFW.set_gamma_ramp @handle, gamma_ramp
    end

    def ==(other : Monitor)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end

    # Sets the immutable monitor connection callback shim.
    private def set_connection_change_callback
      callback = LibGLFW::Monitorfun.new do |handle, event|
        event_label = CrystGLFW[:connected] == event ? :connected : :disconnected
        @@callback_registry[handle].as(ConnectionChangeCallback).try &.call(event_label)
      end
      LibGLFW.set_monitor_callback callback
    end
  end
end
