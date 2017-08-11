module CrystGLFW
  # The Error module encapsulates the handful of GLFW Error types and provides a unified generator for them.
  module Error
    # :nodoc:
    @@labels_and_types = {
      not_initialized:        NotInitialized,
      no_current_context:     NoCurrentContext,
      invalid_enum:           InvalidEnum,
      invalid_value:          InvalidValue,
      out_of_memory:          OutOfMemory,
      api_unavailable:        APIUnavailable,
      version_unavailable:    VersionUnavailable,
      platform_error:         PlatformError,
      format_unavailable:     FormatUnavailable,
      no_window_context:      NoWindowContext,
      not_full_screen:        NotFullScreen,
      key_not_printable:      KeyNotPrintable,
      joystick_not_connected: JoystickNotConnected,
    }

    # :nodoc:
    #
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
    # NOTE: This method may be called outside a `CrystGLFW#run` block definition.
    def self.generate(error_code : Int32) : Error::Any
      error_label = @@labels_and_types.keys.find { |label| error_code == CrystGLFW[label] }
      error_type = @@labels_and_types[error_label.as(Symbol)]
      error_type.new
    end

    # :nodoc
    #
    # Returns an instance of a subclass of `Error::Any` based on the given error label.
    #
    # This method accepts the following arguments:
    # - *error_label*, the label to reference the type of Error.
    #
    # NOTE: This method may be called oustside a `CrystGLFW#run` block definition.
    def self.generate(error_label : Symbol) : Error::Any
      error_type = @@labels_and_types[error_label]
      error_type.new
    end
  end
end
