require "lib_glfw"

module CrystGLFW
  # A Cursor represents a GLFW cursor and can either use a custom image or a system-default shape as its likeness.
  #
  # Cursors are created indirectly through windows, and are therefore always associated with a `Window`.
  struct Cursor
    # :nodoc:
    def initialize(shape : Symbol, window : Window)
      @handle = LibGLFW.create_standard_cursor(CrystGLFW[shape])
      @window = window
      LibGLFW.set_cursor @window, @handle
    end

    # :nodoc:
    def initialize(image : Image, x : Number, y : Number, window : Window)
      @handle = LibGLFW.create_cursor(image, x, y)
      @window = window
      LibGLFW.set_cursor @window, @handle
    end

    # Returns the cursor's window.
    #
    # ```
    # # Get the cursor's associated window.
    # window = cursor.window
    # ```
    def window : Window
      @window
    end

    # Returns the position of the cursor relative to its window.
    #
    # ```
    # cp = cursor.position
    # puts "The cursor position is located at (#{cp[:x]}, #{cp[:y]}) relative to its window."
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position : NamedTuple(x: Float64, y: Float64)
      LibGLFW.get_cursor_pos @window.to_unsafe, out x, out y
      {x: x, y: y}
    end

    # Sets the cursor's position relative to its window.
    #
    # ```
    # # Set the cursor position to the top-left corner of its window.
    # cursor.set_position 0, 0
    # ```
    #
    # This method accepts the following arguments:
    # - *x*, the desired x coordinate of the cursor.
    # - *y*, the desired y coordinate of the cursor.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def set_position(x : Number, y : Number)
      LibGLFW.set_cursor_pos @window.to_unsafe, x, y
    end

    # Alternate syntax for `#set_position`.
    #
    # ```
    # # Set the cursor position to the top-left corner of its window.
    # cursor.position = {x: 0, y: 0}
    # ```
    #
    # This method accepts the following arguments:
    # - *pos*, the desired coordinates of the cursor's position.
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def position=(pos : NamedTuple(x: Number, y: Number))
      set_position pos[:x], pos[:y]
    end

    # Returns true if the cursor is in its window. False otherwise.
    #
    # ```
    # if window.cursor.in_window?
    #   puts "The cursor is in its window!"
    # else
    #   puts "The cursor is somewhere else"
    # end
    # ```
    #
    # NOTE: This method must be called from within a `CrystGLFW#run` block definition.
    def in_window?
      wp = @window.position
      @window.contains? position[:x] + wp[:x], position[:y] + wp[:y]
    end

    # :nodoc:
    #
    # Destroys the underlying GLFW cursor.
    #
    # ```
    # cursor.destroy # GLFW cursor is destroyed, cursor is no longer useable.
    # ```
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def destroy
      LibGLFW.destroy_cursor @handle
    end

    # :nodoc:
    def ==(other : Cursor)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end
  end
end
