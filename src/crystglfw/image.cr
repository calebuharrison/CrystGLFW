require "lib_glfw"

module CrystGLFW
  # An Image object wraps an underlying GLFW Image and exposes its attributes.
  struct Image
    # :nodoc:
    def initialize(handle : Pointer(LibGLFW::Image))
      @handle = handle
    end

    # Returns the width of the image in pixels.
    def width : Int32
      image.width
    end

    # Returns the height of the image in pixels.
    def height : Int32
      image.height
    end

    # Returns the pixel data of the image, arranged left-to-right, top-to-bottom.
    def pixels : Array(UInt8)
      Slice.new(image.pixels, width * height).to_a
    end

    # :nodoc:
    def ==(other : Image)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end

    # Dereferences the underlying GLFW Image pointer.
    private def image
      @handle.value
    end
  end
end
