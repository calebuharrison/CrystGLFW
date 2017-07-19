module CrystGLFW
  module Error
    # Internal GLFW memory allocation failure.
    class OutOfMemory < Any
      @message = "A GLFW memory allocation failed."
    end
  end
end
