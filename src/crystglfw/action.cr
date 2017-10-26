require "lib_glfw"

module CrystGLFW
  enum Action
    Press   = LibGLFW::PRESS
    Release = LibGLFW::RELEASE
    Repeat  = LibGLFW::REPEAT
  end
end