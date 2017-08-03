module CrystGLFW
  module Event
    # Represents an event wherein a window's cursor crosses the threshold of the window.
    struct WindowCursorCrossThreshold < Any
      getter window : CrystGLFW::Window
      getter cursor : CrystGLFW::Cursor

      # :nodoc:
      def initialize(@window, @cursor, @entered : Bool)
      end

      def entered?
        @entered
      end
    end
  end
end
