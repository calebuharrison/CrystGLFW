module CrystGLFW
  module Error
    # One of the arguments given to the method that triggered the error was an invalid value.
    class InvalidValue < Any
      @message = "One of the arguments given to the method that triggered the error was an invalid value."
    end
  end
end
