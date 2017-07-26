module CrystGLFW
  # A MouseButton represents a button on a mouse.
  struct MouseButton

    # All of the mouse button labels defined as constants.
    @@labels : Array(Symbol) = CrystGLFW.constants.keys.select { |label| label.to_s.starts_with?("mouse_button") }

    getter code : Int32

    # :nodoc:
    def initialize(code : Int32)
      @code = code
    end

    # Returns true if the mouse button's label matches the given label. False otherwise.
    #
    # ```
    # window.on_mouse_button do |event|
    #   mouse_button = event.mouse_button
    #   if mouse_button.is? :mouse_button_left
    #     puts "the left mouse button was clicked."
    #   end
    # end
    # ```
    #
    # Also accepts multiple labels and returns true if the mouse button's label matches any of them.
    #
    # ```
    # window.on_mouse_button do |event|
    #   mouse_button = event.mouse_button
    #   if mouse_button.is? :mouse_buton_left, :mouse_button_middle, :mouse_button_right
    #     puts "The mouse button is standard."
    #   else
    #     puts "This must be one of those crazy mice with 100 buttons."
    #   end
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *labels, any number of labels against which the mouse button will be checked.
    def is?(*labels : Symbol) : Bool
      maybe_label = labels.find {|label| @code == CrystGLFW[label]}
      !maybe_label.nil?
    end

    # :nodoc:
    def to_unsafe
      @code
    end
  end
end
