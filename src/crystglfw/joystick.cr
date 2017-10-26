module CrystGLFW

  enum Joystick
    One       = LibGLFW::JOYSTICK_1
    Two       = LibGLFW::JOYSTICK_2
    Three     = LibGLFW::JOYSTICK_3
    Four      = LibGLFW::JOYSTICK_4
    Five      = LibGLFW::JOYSTICK_5
    Six       = LibGLFW::JOYSTICK_6
    Seven     = LibGLFW::JOYSTICK_7
    Eight     = LibGLFW::JOYSTICK_8
    Nine      = LibGLFW::JOYSTICK_9
    Ten       = LibGLFW::JOYSTICK_10
    Eleven    = LibGLFW::JOYSTICK_11
    Twelve    = LibGLFW::JOYSTICK_12
    Thirteen  = LibGLFW::JOYSTICK_13
    Fourteen  = LibGLFW::JOYSTICK_14
    Fifteen   = LibGLFW::JOYSTICK_15
    Sixteen   = LibGLFW::JOYSTICK_16
    Last      = LibGLFW::JOYSTICK_LAST

    def self.on_toggle_connection(&callback : Proc(Event::JoystickToggleConnection, Nil))
      @@callback = callback
    end
  
    protected def self.set_joystick_callback
      callback = LibGLFW::Joystickfun.new do |code, connection_code|
        joystick = Joystick.new(code)
        connection_status = ConnectionStatus.new(connection_code)
        event = Event::JoystickToggleConnection.new(joystick, connection_status)
        @@callback.try &.call(event)
      end
    end

    def name : String
      candidate = LibGLFW.get_joystick_name(@code)
      if candidate.null?
        Error::JoystickNotConnected.raise
      else
        String.new(candidate)
      end
    end

    def connected? : Bool
      LibGLFW.joystick_present(self) == true.hash
    end

    def buttons : Array(Bool)
      btns = LibGLFW.get_joystick_buttons(self, out count)
      Slice.new(btns, count).map { |b| Action.new(b).press? }
    end

    def axes : Slice(Float32)
      ptr = LibGLFW.get_joystick_axes(self, out count)
      Slice.new(ptr, count)
    end

  end

  Joystick.set_joystick_callback
end
