module CrystGLFW
  # A Joystick object wraps an underlying GLFW joystick and exposes its attributes.
  struct Joystick
    alias ToggleConnectionCallback = Proc(Event::JoystickToggleConnection, Nil)
    alias JoystickCallback = ToggleConnectionCallback | Nil

    @@joystick_callback : JoystickCallback
    @@labels : Array(Symbol) = CrystGLFW.constants.keys.select { |label| label.to_s.starts_with?("joystick") }

    # Defines the behavior that gets triggered when a joystick is either connected or disconnected.
    #
    # When GLFW detects that a joystick has either been connected or disconnected, the logic contained
    # in the block defined by this method gets triggered. The joystick that has been connected or
    # disconnected is yielded to the block.
    #
    # ```
    # CrystGLFW::Joystick.on_toggle_connection do |event|
    #   if event.connected?
    #     puts "A new joystick has been connected: #{event.joystick.name}"
    #   else
    #     puts "A joystick has been disconnected: #{event.joystick.name}"
    #   end
    # end
    # ```
    def self.on_toggle_connection(&callback : ToggleConnectionCallback)
      @@joystick_callback = callback
    end

    # Sets the immutable joystick callback shim.
    private def self.set_joystick_callback
      callback = LibGLFW::Joystickfun.new do |code, connected_code|
        joystick = Joystick.new(code)
        connected = connected_code == CrystGLFW[:connected]
        event = Event::JoystickToggleConnection.new(joystick, connected)
        @@joystick_callback.try &.call(event)
      end
    end

    getter code : Int32

    # :nodoc:
    def initialize(code : Int32)
      @code = code
    end

    # Creates a joystick object that wraps an underlying GLFW joystick, identified by the given label.
    #
    # ```
    # joystick = CrystGLFW::Joystick.new(:joystick_last)
    # puts joystick.name if joystick.connected?
    # ```
    #
    # This method accepts the following arguments:
    # - *label*, the Symbol that identifies the virtual GLFW joystick slot.
    def initialize(label : Symbol)
      @code = CrystGLFW[label]
    end

    # Returns the values of all axes of this joystick.
    #
    # ```
    # joystick = CrystGLFW::Joystick.new(:joystick_1)
    # joystick.axes.each_with_index do |axis, i|
    #   puts "The value of axis #{i} is #{axis}"
    # end
    # ```
    def axes : Array(Float32)
      axis_array = LibGLFW.get_joystick_axes(@code, out count)
      Slice.new(axis_array, count).to_a
    end

    # Returns the state of all buttons of this joystick as true or false - press or release.
    #
    # ```
    # joystick = CrystGLFW::Joystick.new(:joystick_1)
    # joystick.buttons.each_with_index do |button, i|
    #   puts "button #{i} is pressed!" if button
    # end
    # ```
    def buttons : Array(Bool)
      buttons = LibGLFW.get_joystick_buttons(@code, out count)
      button_array = Slice.new(buttons, count).to_a
      button_states = button_array.map { |button| button == CrystGLFW[:press] }
      button_states.to_a
    end

    # Returns true if the joystick is connected. False otherwise.
    #
    # ```
    # CrystGLFW::Joystick.on_toggle_connection do |event|
    #   if event.joystick.connected?
    #     puts "A joystick was connected."
    #   else
    #     puts "A joystick was disconnected."
    #   end
    # end
    # ```
    def connected? : Bool
      LibGLFW.joystick_present(@code) == CrystGLFW[:true]
    end

    # Returns true if the joystick is referenced by the given label. False otherwise.
    #
    # ```
    # CrystGLFW::Joystick.on_toggle_connection do |event|
    #   if event.joystick.is? :joystick_last
    #     puts "A joystick has been connected in the last joystick slot!"
    #   end
    # end
    # ```
    #
    # Also accepts multiple labels and returns true if the joystick is matched by any of them.
    #
    # ```
    # CrystGLFW::Joystick.on_toggle_connection do |event|
    #   if event.joystick.is? :joystick_1, :joystick_2, :joystick_3, :joystick_4
    #     puts "One of the first four joystick slots has been used."
    #   end
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *labels*, any number of labels against which the joystick will be matched.
    def is?(*labels : Symbol) : Bool
      maybe_label = labels.find { |label| @code == CrystGLFW[label] }
      !maybe_label.nil?
    end

    # Retrieves the joystick's default name if the joystick is connected. Otherwise, raises an exception.
    #
    # if joystick.connected?
    #   puts joystick.name # prints the joystick's name
    # end
    #
    # NOTE: This method must be called from within a `run` block definition.
    def name : String
      candidate = LibGLFW.get_joystick_name(@code)
      if candidate.null?
        raise Error.generate(:joystick_not_connected)
      else
        String.new(candidate)
      end
    end

    set_joystick_callback
  end
end
