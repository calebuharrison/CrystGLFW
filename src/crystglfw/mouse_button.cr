module CrystGLFW
  struct MouseButton
    @@labels : Array(Symbol) = CrystGLFW.constants.keys.select { |label| label.to_s.starts_with?("mouse_button") }

    def self.labels
      @@labels
    end

    getter code : Int32

    def initialize(code : Int32)
      @code = code
    end

    def ==(other : MouseButton)
      @code == other.code
    end

    def is?(label : Symbol)
      @code == CrystGLFW.constants[label]
    end

    def to_unsafe
      @code
    end
  end
end
