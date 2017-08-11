module CrystGLFW
  module Error
    # Caller assumed window was in full screen mode without making a full_screen? check
    class NotFullScreen < Any
      @message = "Caller assumed window was in full screen mode. Does your logic include a check to `Window#full_screen?`?"
    end
  end
end
