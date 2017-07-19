module CrystGLFW
  module Error
    # Error::Any is the functionally abstract superclass of the different CrystGLFW errors.
    class Any < Exception
      @code : Int32
      @message = "An error occurred."

      # Returns a new Error::Any with the given error code.
      #
      # This method accepts the following arguments:
      # - *code*, the error code yielded by `CrystGLFW.on_error`
      #
      # NOTE: This method may be called outside a `#run` block definition without triggering an error.
      def initialize(code : Int32)
        @code = code
      end
    end
  end
end
