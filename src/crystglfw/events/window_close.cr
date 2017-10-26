module CrystGLFW
  module Event
    # Represents an event wherein a window is closed.
    struct WindowClose < Any
      getter window : Window

      # :nodoc:
      def initialize(window : Window)
        @window = window
      end
    end
  end
end
