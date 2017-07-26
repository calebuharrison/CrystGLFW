module CrystGLFW
  module Event
    # Represents an event wherein a joystick is either connected or disconnected from the system.
    struct JoystickToggleConnection < Any
      getter joystick : CrystGLFW::Joystick

      # :nodoc:
      def initialize(@joystick : CrystGLFW::Joystick, @connected : Bool)
      end

      def connected?
        @connected
      end
    end
  end
end
