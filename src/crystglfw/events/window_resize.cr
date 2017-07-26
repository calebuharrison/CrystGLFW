module CrystGLFW
  module Event
    # Represents an event wherein a window is resized.
    struct WindowResize < Any

      getter window : CrystGLFW::Window
      getter width  : Int32
      getter height : Int32
      
      # :nodoc:
      def initialize(@window, @width, @height)
      end
    end
  end
end
