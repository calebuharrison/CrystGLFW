module CrystGLFW
  module Event
    # Represents an event wherein a window is refreshed.
    struct WindowRefresh < Any
      getter window : Window

      # :nodoc:
      def initialize(window : Window)
        @window = window
      end
    end
  end
end
