module CrystGLFW
  module Event
    # Represents an event wherein a window is moved to a new location.
    struct WindowMove < Any
      getter window : Window

      # :nodoc:
      def initialize(@window : Window, @x : Int32, @y : Int32)
      end

      def position : NamedTuple(x: Int32, y: Int32)
        { x: @x, y: @y }
      end
    end
  end
end
