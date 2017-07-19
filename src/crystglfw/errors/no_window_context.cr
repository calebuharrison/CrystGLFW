module CrystGLFW
  module Error
    # Window without OpenGL context was passed to a context-dependent method.
    class NoWindowContext < Any
      @message = "Window without OpenGL context was passed to a context-dependent method."
    end
  end
end
