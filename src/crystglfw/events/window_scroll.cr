module CrystGLFW
  module Event
    # Represents an event wherein a window receives scroll input.
    struct WindowScroll < Any
      getter window : Window

      # :nodoc:
      def initialize(@window : Window, @x : Float64, @y : Float64)
      end

      def offset : NamedTuple(x: Float64, y: Float64)
        { x: @x, y: @y }
      end
    end
  end
end
