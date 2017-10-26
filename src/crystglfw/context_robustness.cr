module CrystGLFW
  enum ContextRobustness
    None                = LibGLFW::NO_ROBUSTNESS
    NoResetNotification = LibGLFW::NO_RESET_NOTIFICATION
    LoseContextOnReset  = LibGLFW::LOSE_CONTEXT_ON_RESET
  end
end