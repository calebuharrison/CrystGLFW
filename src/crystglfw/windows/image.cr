require "lib_glfw"

module CrystGLFW
  class Window
    # An Image object wraps an underlying GLFW Image and exposes its attributes.
    struct Image
      @image : LibGLFW::Image

      # Create a new image for use as a Cursor image or a Window icon.
      #
      # ```
      # width, height = 16, 32
      # pixels = Array(UInt8).new(width * height, 255_u8)
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

      def size : NamedTuple(width: Int32, height: Int32)
        { width: @image.width, height: @image.height }
      end

      # Returns the pixel data of the image, arranged left-to-right, top-to-bottom.
      def pixels : Slice(UInt8)
        Slice.new(@image.pixels, width * height)
      end

      # :nodoc:
      def to_unsafe
        pointerof(@image)
      end
    end
  end
end
