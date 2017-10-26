module CrystGLFW
  module Event
    # Represents an event wherein a window is resized.
    struct WindowResize < Any
      getter window : Window

      # :nodoc:
      def initialize(@window : Window, @width : Int32, @height : Int32)
      end

      def size : NamedTuple(width: Int32, height: Int32)
        { width: @width, height: @height }
      end
    end
  end
end
