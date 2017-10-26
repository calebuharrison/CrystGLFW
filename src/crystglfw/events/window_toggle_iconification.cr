module CrystGLFW
  module Event
    # Represents an event wherein a window's iconification is toggled on or off.
    struct WindowToggleIconification < Any
      getter window : Window

      # :nodoc:
      def initialize(@window : Window, @iconified : Bool)
      end

      def iconified?
        @iconified
      end
    end
  end
end
