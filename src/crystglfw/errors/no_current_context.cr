module CrystGLFW
  module Error
    # No context is current on the calling thread.
    class NoCurrentContext < Any
      @message = "No context is current on the calling thread."
    end
  end
end
