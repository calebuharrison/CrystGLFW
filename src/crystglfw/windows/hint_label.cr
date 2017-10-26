module CrystGLFW
  class Window
    enum HintLabel
      Resizable               = LibGLFW::RESIZABLE
      Visible                 = LibGLFW::VISIBLE
      Decorated               = LibGLFW::DECORATED
      Focused                 = LibGLFW::FOCUSED
      AutoIconify             = LibGLFW::AUTO_ICONIFY
      Floating                = LibGLFW::FLOATING
      Maximized               = LibGLFW::MAXIMIZED
      RedBits                 = LibGLFW::RED_BITS
      GreenBits               = LibGLFW::GREEN_BITS
      BlueBits                = LibGLFW::BLUE_BITS
      AlphaBits               = LibGLFW::ALPHA_BITS
      DepthBits               = LibGLFW::DEPTH_BITS
      StencilBits             = LibGLFW::STENCIL_BITS
      AccumRedBits            = LibGLFW::ACCUM_RED_BITS
      AccumGreenBits          = LibGLFW::ACCUM_GREEN_BITS
      AccumBlueBits           = LibGLFW::ACCUM_BLUE_BITS
      AccumAlphaBits          = LibGLFW::ACCUM_ALPHA_BITS
      AuxBuffers              = LibGLFW::AUX_BUFFERS
      Samples                 = LibGLFW::SAMPLES
      RefreshRate             = LibGLFW::REFRESH_RATE
      Stereo                  = LibGLFW::STEREO
      SRGBCapable             = LibGLFW::SRGB_CAPABLE
      Doublebuffer            = LibGLFW::DOUBLEBUFFER
      ClientAPI               = LibGLFW::CLIENT_API
      ContextCreationAPI      = LibGLFW::CONTEXT_CREATION_API
      ContextVersionMajor     = LibGLFW::CONTEXT_VERSION_MAJOR
      ContextVersionMinor     = LibGLFW::CONTEXT_VERSION_MINOR
      ContextRobustness       = LibGLFW::CONTEXT_ROBUSTNESS
      ContextReleaseBehavior  = LibGLFW::CONTEXT_RELEASE_BEHAVIOR
      OpenGLForwardCompat     = LibGLFW::OPENGL_FORWARD_COMPAT
      OpenGLDebugContext      = LibGLFW::OPENGL_DEBUG_CONTEXT
      OpenGLProfile           = LibGLFW::OPENGL_PROFILE
    end
  end
end