module CrystGLFW
  module Event
    # Represents an event wherein one or more files are drag-and-dropped onto the window.
    struct WindowFileDrop < Any
      getter window : CrystGLFW::Window
      getter paths : Array(String)

      # :nodoc:
      def initialize(window, paths)
        @window = window
        @paths = paths
      end
    end
  end
end
