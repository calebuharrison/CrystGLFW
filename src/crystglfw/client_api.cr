module CrystGLFW
  enum ClientAPI
    OpenGL    = LibGLFW::OPENGL_API
    OpenGLES  = LibGLFW::OPENGL_ES_API
    None      = LibGLFW::NO_API
  end
end