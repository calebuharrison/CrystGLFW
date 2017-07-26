module CrystGLFW
  module Event
    # Represents an event wherein a window is closed.
    struct WindowClose < Any

      getter window : CrystGLFW::Window
      
      # :nodoc:
      def initialize(window)
        @window = window
      end
    end
  end
end
