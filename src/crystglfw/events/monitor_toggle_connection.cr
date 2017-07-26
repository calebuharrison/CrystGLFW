module CrystGLFW
  module Event
    # Represents an event wherein a monitor is either connected or disconnected from the system.
    struct MonitorToggleConnection < Any
      getter monitor : CrystGLFW::Monitor

      # :nodoc:
      def initialize(@monitor : CrystGLFW::Monitor, @connected : Bool)
      end

      def connected?
        @connected
      end
    end
  end
end
