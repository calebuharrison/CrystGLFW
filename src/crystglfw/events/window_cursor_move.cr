module CrystGLFW
  module Event
    # Represents an event wherein a window's cursor is moved to a new location.
    struct WindowCursorMove < Any
      getter window : Window
      getter cursor : Window::Cursor

      # :nodoc:
      def initialize(@window : Window, @cursor : Window::Cursor, @x : Float64, @y : Float64)
      end

      def position : NamedTuple(x: Float64, y: Float64)
        { x: @x, y: @y }
      end
    end
  end
end
