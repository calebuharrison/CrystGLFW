module CrystGLFW
  # The Error module encapsulates the handful of GLFW Error types and provides a unified generator for them.
  module Error
    # :nodoc:
    @@labels_and_types = {
      not_initialized:     NotInitialized,
      no_current_context:  NoCurrentContext,
      invalid_enum:        InvalidEnum,
      invalid_value:       InvalidValue,
      out_of_memory:       OutOfMemory,
      api_unavailable:     APIUnavailable,
      version_unavailable: VersionUnavailable,
      platform_error:      PlatformError,
      format_unavailable:  FormatUnavailable,
      no_window_context:   NoWindowContext,
    }

    # Returns an instance of a subclass of `Error::Any` based on the given error code.
    #
    # ```
    # CrystGLFW.on_error do |error_code|
    #   raise Error.generate error_code # Raises a specific type of exception determined by the error code.
    # end
    # ```
    #
    # This method accepts the following arguments:
    # - *error_code*, the code yielded by `CrystGLFW#on_error'
    #
    # NOTE: This method may be called outside a `#run` block definition without triggering an error.
    def self.generate(error_code : Int32)
      error_label = @@labels_and_types.keys.find { |label| error_code == CrystGLFW.constants[label] }
      error_type = @@labels_and_types[error_label.as(Symbol)]
      error_type.new(error_code)
    end
  end
end
