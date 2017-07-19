module CrystGLFW
  struct MouseButtonEvent
    @@actions : Array(Symbol) = [:press, :release]
    @mouse_button : MouseButton
    @action : Symbol | Nil
    @mod_shift : Bool
    @mod_control : Bool
    @mod_alt : Bool
    @mod_super : Bool

    def initialize(mouse_button : MouseButton, action_code : Int32, modifiers : Int32)
      @mouse_button = mouse_button
      @action = @@actions.find { |action| CrystGLFW.constants[action] == action_code }
      @mod_shift = modifiers.bit(0) == 1
      @mod_control = modifiers.bit(1) == 1
      @mod_alt = modifiers.bit(2) == 1
      @mod_super = modifiers.bit(3) == 1
    end

    def mouse_button
      @mouse_button
    end

    def action
      @action
    end

    def press?
      @action == :press
    end

    def release?
      @action == :release
    end

    def shift?
      @mod_shift
    end

    def control?
      @mod_control
    end

    def alt?
      @mod_alt
    end

    def super?
      @mod_super
    end
  end
end
