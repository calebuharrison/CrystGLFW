module CrystGLFW
  class Window
    enum State
      Focused   = LibGLFW::FOCUSED
      Iconified = LibGLFW::ICONIFIED
      Resizable = LibGLFW::RESIZABLE
      Visible   = LibGLFW::VISIBLE
      Decorated = LibGLFW::DECORATED
      Floating  = LibGLFW::FLOATING
      Maximized = LibGLFW::MAXIMIZED
    end
  end
end