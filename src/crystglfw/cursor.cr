require "lib_glfw"

module CrystGLFW
  # A Cursor represents a GLFW cursor and can either use a custom image or a system-default shape as its likeness.
  #
  # After a cursor object is created, it can be attached to a window via `Window#cursor=`.
  #
  # Due to the way cursors are implemented in GLFW, a Cursor object's position must be
  # queried indirectly through its associated Window object via `Window#cursor_position`.
  struct Cursor
    # Returns a new Cursor object with the given system-default shape.
    #
    # ```
    # cursor = CrystGLFW::Cursor.new :hand_cursor # Creates a cursor with a hand shape.
    # ```
    #
    # This method accepts the following arguments:
    # - *shape*, the system-default shape that the Cursor object will take on.
    #
    # *shape* can be any one of the following values:
    # - :arrow_cursor
    # - :ibeam_cursor
    # - :crosshair_cursor
    # - :hand_cursor
    # - :hresize_cursor
    # - :vresize_cursor
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def initialize(shape : Symbol)
      @handle = LibGLFW.create_standard_cursor(CrystGLFW[shape])
    end

    # Returns a new Cursor object with the given image shape and hotspot.
    #
    # ```
    # cursor = CrystGLFW::Cursor.new cool_image, 6, 6 # Creates a cursor that looks like cool_image with hotspot (6,6)
    # ```
    #
    # This method accepts the following arguments:
    # - *image*, the shape of the Cursor object.
    # - *x*, the x-coordinate of the Cursor object's hotspot.
    # - *y*, the y-coordinate of the Cursor object's hotspot.
    #
    # NOTE: This method must be called inside a `CrystGLFW#run` block definition.
    def initialize(image : Image, x : Int32, y : Int32)
      @handle = LibGLFW.create_cursor(image, x, y)
    end

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

    def ==(other : Cursor)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end
  end
end
