module CrystGLFW
  module Error
    # If emitted during window creation, one or more hard constraints did not match any of the available pixel formats.
    # If emitted when querying the clipboard, the contents of the clipboard could not be converted to the requested format.
    class FormatUnavailable < Any
      @message = "Either the requested pixel format is not supported or the contents of the clipboard could not be converted to the requested format."
    end
  end
end
