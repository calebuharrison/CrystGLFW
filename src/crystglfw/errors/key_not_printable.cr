module CrystGLFW
  module Error
    # Caller assumed key was printable without making a `CrystGLFW::Key#printable?` check.
    class KeyNotPrintable < Any
      @message = "Caller assumed key was printable by asking for its name. Does your logic include a check to `Key#printable?`?"
    end
  end
end
