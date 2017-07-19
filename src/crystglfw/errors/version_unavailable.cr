module CrystGLFW
  module Error
    # The requested version of OpenGL or OpenGL ES is unavailable.
    class VersionUnavailable < Any
      @message = "The requested version of OpenGL is unavailable."
    end
  end
end
