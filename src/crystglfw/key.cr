module CrystGLFW
  # A key represents a physical key on the keyboard.
  struct Key
    # All of the key-specific labels defined as constants.
    @@labels : Array(Symbol) = CrystGLFW.constants.keys.select { |label| label.to_s.starts_with?("key") }

    # All of the key labels that represent a printable key.
    @@printable_key_labels = [:key_apostrophe, :key_comma, :key_minus, :key_period, :key_slash, :key_semicolon, :key_equal,
                              :key_left_bracket, :key_right_bracket, :key_backslash, :key_world_1, :key_world_2, :key_0, :key_1,
                              :key_2, :key_3, :key_4, :key_5, :key_6, :key_7, :key_8, :key_9, :key_a, :key_b, :key_c, :key_d, :key_e,
                              :key_f, :key_g, :key_h, :key_i, :key_j, :key_k, :key_l, :key_m, :key_n, :key_o, :key_p, :key_q, :key_r,
                              :key_s, :key_t, :key_u, :key_v, :key_w, :key_x, :key_y, :key_z, :key_kp_0, :key_kp_1, :key_kp_2,
                              :key_kp_3, :key_kp_4, :key_kp_5, :key_kp_6, :key_kp_7, :key_kp_8, :key_kp_9, :key_kp_decimal,
                              :key_kp_divide, :key_kp_multiply, :key_kp_subtract, :key_kp_add, :key_kp_equal]

    getter code : Int32
    getter scancode : Int32

    # :nodoc:
    def initialize(code : Int32, scancode : Int32)
      @code = code
      @scancode = scancode
    end

    # Returns true if the key is considered printable. False otherwise.
    #
    # ```
    # window.on_key do |key_event|
    #   key = key_event.key
    #   puts key.name if key.printable?
    # end
    # ```
    def printable? : Bool
      label = @@printable_key_labels.find { |label| @code == CrystGLFW[label] }
      !label.nil?
    end

    # :nodoc:
    def ==(other : Key)
      @scancode == other.scancode
    end

    # Returns true if the key is referenced by the given label. False otherwise.
    #
    # ```
    # window.on_key do |key_event|
    #   key = key_event.key
    #   if key.is? :key_a
    #     puts "the 'a' key was pressed."
    #   end
    # end
    # ```
    #
    # Also accepts multiple labels and returns true if the key's label matches any of them.
    #
    # ```
    # window.on_key do |key_event|
    #   key = key_event.key
    #   if key.is? :key_a, :key_b, :key_c
    #     puts "A, B, C!"
    #   elsif key.is? :key_1, :key_2, :key_3
    #     puts "Easy as 1, 2, 3!"
    #   else
    #     puts "Uh...do, re, mi?"
    #   end
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *labels*, any number of labels against which the key will be checked.
    def is?(*labels : Symbol) : Bool
      maybe_label = labels.find { |label| @code == CrystGLFW[label] }
      !maybe_label.nil?
    end

    # Returns the key's name, if the key is printable. Otherwise raises an exception.
    #
    # ```
    # if key.printable?
    #   puts key.name # prints the key's name
    # end
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def name
      candidate = LibGLFW.get_key_name(@code, @scancode)
      if candidate.null?
        raise Error.generate(:key_not_printable)
      else
        String.new(candidate)
      end
    end

    # :nodoc:
    def to_unsafe : Int32
      @code
    end
  end
end
