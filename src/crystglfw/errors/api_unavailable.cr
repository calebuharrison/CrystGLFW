module CrystGLFW
  module Error
    # The installed graphics driver does not support the requested API, or does not support it
    # via the chosen context creation backend.
    class APIUnavailable < Any
      @message = "GLFW could not find support for the requested API on the system."
    end
  end
end
