module CrystGLFW
  module Event
    # Represents an event wherein a window's cursor crosses the threshold of the window.
    struct WindowCursorCrossThreshold < Any

      getter window : CrystGLFW::Window
      
      # :nodoc:
      def initialize(@window, @entered)
      end

      def entered?
        @entered
      end
    end
  end
end
