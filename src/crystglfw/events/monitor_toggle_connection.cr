module CrystGLFW
  module Event
    # Represents an event wherein a monitor is either connected or disconnected from the system.
    struct MonitorToggleConnection < Any
      getter monitor : Monitor

      # :nodoc:
      def initialize(@monitor : Monitor, @connection_status : ConnectionStatus)
      end

      def connected?
        @connection_status.connected?
      end
    end
  end
end
