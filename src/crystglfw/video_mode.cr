require "lib_glfw"

module CrystGLFW
  # A VideoMode object wraps an underlying GLFW Vidmode and exposes its attributes.
  struct VideoMode

    # :nodoc:
    def initialize(handle : Pointer(LibGLFW::Vidmode))
      @handle = handle
    end

    # Returns the bit depth of the red channel.
    def red_bits : Int32
      vid_mode.redBits
    end

    # Returns the bit depth of the green channel.
    def green_bits : Int32
      vid_mode.greenBits
    end

    # Returns the bit depth of the blue channel.
    def blue_bits : Int32
      vid_mode.blueBits
    end

    # Returns the width, in screen coordinates, of the video mode.
    def width : Int32
      vid_mode.width
    end

    # Returns the height, in screen coordinates, of the video mode.
    def height : Int32
      vid_mode.height
    end

    # Returns the refresh rate, in Hz, of the video mode.
    def refresh_rate : Int32
      vid_mode.refreshRate
    end

    # :nodoc:
    def ==(other : VideoMode)
      @handle == other.to_unsafe
    end

    # :nodoc:
    def to_unsafe
      @handle
    end

    # Dereferences the pointer to the GLFW Vidmode.
    private def vid_mode
      @handle.value
    end
  end
end
