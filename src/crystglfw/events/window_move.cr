module CrystGLFW
  module Event
    # Represents an event wherein a window is moved to a new location.
    struct WindowMove < Any

      getter window : CrystGLFW::Window
      getter x      : Int32
      getter y      : Int32
      
      # :nodoc:
      def initialize(@window, @x, @y)
      end
    end
  end
end
