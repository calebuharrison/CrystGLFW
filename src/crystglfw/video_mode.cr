require "lib_glfw"

module CrystGLFW
  struct VideoMode
    def initialize(handle : Pointer(LibGLFW::Vidmode))
      @handle = handle
    end

    def red_bits
      vid_mode.redBits
    end

    def green_bits
      vid_mode.greenBits
    end

    def blue_bits
      vid_mode.blueBits
    end

    def width
      vid_mode.width
    end

    def height
      vid_mode.height
    end

    def refresh_rate
      vid_mode.refreshRate
    end

    def ==(other : VideoMode)
      @handle == other.to_unsafe
    end

    def to_unsafe
      @handle
    end

    private def vid_mode
      @handle.value
    end
  end
end
