module CrystGLFW
  module Event
    # Represents an event wherein a window's framebuffer is resized.
    struct WindowFramebufferResize < Any
      getter window : CrystGLFW::Window

      # :nodoc:
      def initialize(@window : Window, @width : Int32, @height : Int32)
      end

      def size : NamedTuple(width: Int32, height: Int32)
        { width: @width, height: @height }
      end
    end
  end
end
