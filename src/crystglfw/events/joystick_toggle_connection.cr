module CrystGLFW
  module Event
    # Represents an event wherein a joystick is either connected or disconnected from the system.
    struct JoystickToggleConnection < Any
      getter joystick : Joystick

      # :nodoc:
      def initialize(joystick : Joystick, connection_status : ConnectionStatus)
        @joystick           = joystick
        @connection_status  = connection_status
      end

      def connected?
        @connection_status.connected?
      end
    end
  end
end