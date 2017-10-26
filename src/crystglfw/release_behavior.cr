module CrystGLFW
  enum ReleaseBehavior
    Any   = LibGLFW::ANY_RELEASE_BEHAVIOR
    Flush = LibGLFW::RELEASE_BEHAVIOR_FLUSH
    None  = LibGLFW::RELEASE_BEHAVIOR_NONE
  end
end