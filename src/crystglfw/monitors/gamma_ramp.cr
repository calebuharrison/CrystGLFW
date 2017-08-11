require "lib_glfw"

module CrystGLFW
  struct Monitor
    # A GammaRamp object wraps an underlying GLFW Gammaramp and exposes its attributes.
    struct GammaRamp
      # :nodoc:
      def initialize(handle : Pointer(LibGLFW::Gammaramp))
        @handle = handle
      end

      # Returns an array of values that describes the response of the red channel.
      #
      # ```
      # monitor = Monitor.primary
      # gamma_ramp = monitor.gamma_ramp
      # gamma_ramp.red
      # ```
      def red : Array(UInt16)
        Slice.new(gamma_ramp.red, size).to_a
      end

      # Returns an array of values that describes the resposne of the green channel.
      #
      # ```
      # monitor = Monitor.primary
      # gamma_ramp = monitor.gamma_ramp
      # gamma_ramp.green
      # ```
      def green : Array(UInt16)
        Slice.new(gamma_ramp.green, size).to_a
      end

      # Returns an array of values that describes the response of the blue channel.
      #
      # ```
      # monitor = Monitor.primary
      # gamma_ramp = monitor.gamma_ramp
      # gamma_ramp.blue
      # ```
      def blue : Array(UInt16)
        Slice.new(gamma_ramp.blue, size).to_a
      end

      # Returns the response values of each channel.
      #
      # ```
      # monitor = Monitor.primary
      # gamma_ramp = monitor.gamma_ramp
      # channels = gamma_ramp.channels
      # red_response = channels[:red]
      # green_response = channels[:green]
      # blue_response = channels[:blue]
      # ```
      def channels : NamedTuple(red: Array(UInt16), green: Array(UInt16), blue: Array(UInt16))
        {red: red, green: green, blue: blue}
      end

      # Returns the number of elements in each color array.
      #
      # ```
      # monitor = Monitor.primary
      # gamma_ramp = monitor.gamma_ramp
      # gamma_ramp.size
      # ```
      def size : UInt32
        gamma_ramp.size
      end

      # :nodoc:
      def ==(other : GammaRamp)
        @handle == other.to_unsafe
      end

      # :nodoc:
      def to_unsafe
        @handle
      end

      # Dereferences the underlying Gammaramp pointer.
      private def gamma_ramp
        @handle.value
      end
    end
  end
end
