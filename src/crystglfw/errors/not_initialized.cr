module CrystGLFW
  module Error
    # GLFW is not initialized.
    class NotInitialized < Any
      @message = "GLFW is not initialized"
    end
  end
end
