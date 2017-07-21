require "lib_glfw"

module CrystGLFW
  # An Image object wraps an underlying GLFW Image and exposes its attributes.
  struct Image

    @image : LibGLFW::Image

    # Create a new image for use as a Cursor image or a Window icon.
    #
    # ```
    # width, height = 4, 4
    # pixels = Array(UInt8).new(width * height, 0_u8)
    # image = CrystGLFW::Image.new(width, height, pixels)
    # ```
    #
    # This method accepts the following arguments:
    # - *width*, the width of the image, in pixels.
    # - *height*, the height of the image, in pixels.
    # - *pixels*, the pixel data, given left-to-right, top-to-bottom.
    # 
    # NOTE: This method may be called outside a `CrystGLFW#run` block defintion without triggering an error.
    def initialize(width : Int32, height : Int32, pixels : Array(UInt8))
      @image = LibGLFW::Image.new
      @image.width = width
      @image.height = height
      @image.pixels = pixels
    end

    # Returns the width of the image in pixels.
    def width : Int32
      @image.width
    end

    # Returns the height of the image in pixels.
    def height : Int32
      @image.height
    end

    # Returns the pixel data of the image, arranged left-to-right, top-to-bottom.
    def pixels : Array(UInt8)
      Slice.new(@image.pixels, width * height).to_a
    end

    # :nodoc:
    def to_unsafe
      pointerof(@image)
    end
  end
end
