module CrystGLFW
  module Error
    # Caller assumed joystick was connected when it was not.
    class JoystickNotConnected < Any
      @message = "Caller assumed joystick was connected by asking for its name. Does your logic include a check to `Joystick#connected?`?"
    end
  end
end
