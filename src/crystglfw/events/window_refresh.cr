module CrystGLFW
  module Event
    # Represents an event wherein a window is refreshed.
    struct WindowRefresh < Any
      getter window : CrystGLFW::Window

      # :nodoc:
      def initialize(window)
        @window = window
      end
    end
  end
end
