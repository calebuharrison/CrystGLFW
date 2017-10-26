module CrystGLFW
  module Event
    # Represents an event wherein a window's cursor crosses the threshold of the window.
    struct WindowCursorCrossThreshold < Any
      getter window : Window
      getter cursor : Window::Cursor

      # :nodoc:
      def initialize(@window : Window, @cursor : Window::Cursor, @entered : Bool)
      end

      def entered?
        @entered
      end
    end
  end
end
