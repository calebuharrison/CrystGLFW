module CrystGLFW
  module Error
    # One of the arguments given to the method that triggered the error was an invalid enum value.
    class InvalidEnum < Any
      @message = "One of the arguments given to the method that triggered the error was an invalid enum value."
    end
  end
end
