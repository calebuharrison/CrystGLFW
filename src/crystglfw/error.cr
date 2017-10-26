module CrystGLFW
  enum Error
    NotInitialized        = LibGLFW::NOT_INITIALIZED
    NoCurrentContext      = LibGLFW::NO_CURRENT_CONTEXT
    InvalidEnum           = LibGLFW::INVALID_ENUM
    InvalidValue          = LibGLFW::INVALID_VALUE
    OutOfMemory           = LibGLFW::OUT_OF_MEMORY
    APIUnavailable        = LibGLFW::API_UNAVAILABLE
    VersionUnavailable    = LibGLFW::VERSION_UNAVAILABLE
    PlatformError         = LibGLFW::PLATFORM_ERROR
    FormatUnavailable     = LibGLFW::FORMAT_UNAVAILABLE
    NoWindowContext       = LibGLFW::NO_WINDOW_CONTEXT
    NotFullScreen
    KeyNotPrintable
    JoystickNotConnected

    def raise
      raise "CrystGLFW Error: " + self.to_s
    end
  end
end
