module CrystGLFW
  module Event
    # Represents an event wherein a window receives scroll input.
    struct WindowScroll < Any

      getter window : CrystGLFW::Window
      getter x      : Float64
      getter y      : Float64
      
      # :nodoc:
      def initialize(@window, @x, @y)
      end
    end
  end
end
