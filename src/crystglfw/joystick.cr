module CrystGLFW
  # A Joystick object wraps an underlying GLFW joystick and exposes its attributes.
  struct Joystick
    alias ConnectionChangeCallback = Proc(Joystick, Nil)
    alias JoystickCallback = ConnectionChangeCallback | Nil

    @@joystick_callback : JoystickCallback
    @@labels : Array(Symbol) = CrystGLFW.constants.keys.select { |label| label.to_s.starts_with?("joystick") }

    # Returns an array of Symbols that reference GLFW joysticks.
    def self.labels
      @@labels
    end

    # Defines the behavior that gets triggered when a joystick is either connected or disconnected.
    #
    # When GLFW detects that a joystick has either been connected or disconnected, the logic contained
    # in the block defined by this method gets triggered. The joystick that has been connected or
    # disconnected is yielded to the block.
    #
    # ```
    # CrystGLFW::Joystick.on_connection_change do |joystick|
    #   if joystick.connected?
    #     puts "A new joystick has been connected: #{joystick.name}"
    #   else
    #     puts "A joystick has been disconnected: #{joystick.name}"
    #   end
    # end
    # ```
    def self.on_connection_change(&callback)
      @@joystick_callback = callback
    end

    # Sets the immutable joystick callback shim.
    private def self.set_joystick_callback
      callback = LibGLFW::Joystickfun.new do |code, connected?|
        joystick = Joystick.new(code)
        @@joystick_callback.try &.call(joystick)
      end
    end

    getter name : String | Nil
    getter code : Int32

    # :nodoc:
    def initialize(code : Int32)
      @code = code
      @name = joystick_name
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
      @name = joystick_name
    end

    # Returns the values of all axes of this joystick.
    #
    # ```
    # joystick = CrystGLFW::Joystick.new(:joystick_1)
    # joystick.axes.each_with_index do |axis, i|
    #   puts "The value of axis #{i} is #{axis}"
    # end
    # ```
    def axes
      axis_array = LibGLFW.get_joystick_axes(@code, out count)
      Slice.new(axis_array, count).to_a
    end

    # Returns the state of all buttons of this joystick.
    #
    # ```
    # joystick = CrystGLFW::Joystick.new(:joystick_1)
    # joystick.buttons.each_with_index do |button, i|
    #   puts "button #{i} is pressed!" if button == :press
    # end
    # ```
    def buttons
      buttons = LibGLFW.get_joystick_buttons(@code, out count)
      button_array = Slice.new(buttons, count).to_a
      button_states = button_array.map { |button| button == CrystGLFW[:press] ? :press : :release }
      button_states.to_a
    end

    # Returns true if the joystick is connected. False otherwise.
    #
    # ```
    # CrystGLFW::Joystick.on_connection_change do |joystick|
    #   if joystick.connected?
    #     puts "A joystick was connected."
    #   else
    #     puts "A joystick was disconnected."
    #   end
    # end
    # ```
    def connected?
      LibGLFW.joystick_present(@code) == CrystGLFW[:true]
    end

    # Returns true if the joystick is referenced by the given label. False otherwise.
    #
    # ```
    # CrystGLFW::Joystick.on_connection_change do |joystick|
    #   if joystick.is? :joystick_last
    #     puts "A joystick has been connected in the last joystick slot!"
    #   end
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *label*, the Symbol that identifies the virtual GLFW joystick slot.
    def is?(label : Symbol)
      @code == CrystGLFW[label]
    end

    # Retrieves the joystick's default name if the joystick is connected.
    private def joystick_name
      joy_name = LibGLFW.get_joystick_name(@code)
      if joy_name
        String.new(joy_name)
      else
        nil
      end
    end

    set_joystick_callback
  end
end
