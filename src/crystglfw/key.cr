module CrystGLFW
  enum Key
    Unknown       = LibGLFW::KEY_UNKNOWN
    Space         = LibGLFW::KEY_SPACE
    Apostrophe    = LibGLFW::KEY_APOSTROPHE
    Comma         = LibGLFW::KEY_COMMA
    Minus         = LibGLFW::KEY_MINUS
    Period        = LibGLFW::KEY_PERIOD
    Slash         = LibGLFW::KEY_SLASH
    Zero          = LibGLFW::KEY_0
    One           = LibGLFW::KEY_1
    Two           = LibGLFW::KEY_2
    Three         = LibGLFW::KEY_3
    Four          = LibGLFW::KEY_4
    Five          = LibGLFW::KEY_5
    Six           = LibGLFW::KEY_6
    Seven         = LibGLFW::KEY_7
    Eight         = LibGLFW::KEY_8
    Nine          = LibGLFW::KEY_9
    Semicolon     = LibGLFW::KEY_SEMICOLON
    Equal         = LibGLFW::KEY_EQUAL
    A             = LibGLFW::KEY_A
    B             = LibGLFW::KEY_B
    C             = LibGLFW::KEY_C
    D             = LibGLFW::KEY_D
    E             = LibGLFW::KEY_E
    F             = LibGLFW::KEY_F
    G             = LibGLFW::KEY_G
    H             = LibGLFW::KEY_H
    I             = LibGLFW::KEY_I
    J             = LibGLFW::KEY_J
    K             = LibGLFW::KEY_K
    L             = LibGLFW::KEY_L
    M             = LibGLFW::KEY_M
    N             = LibGLFW::KEY_N
    O             = LibGLFW::KEY_O
    P             = LibGLFW::KEY_P
    Q             = LibGLFW::KEY_Q
    R             = LibGLFW::KEY_R
    S             = LibGLFW::KEY_S
    T             = LibGLFW::KEY_T
    U             = LibGLFW::KEY_U
    V             = LibGLFW::KEY_V
    W             = LibGLFW::KEY_W
    X             = LibGLFW::KEY_X
    Y             = LibGLFW::KEY_Y
    Z             = LibGLFW::KEY_Z
    LeftBracket   = LibGLFW::KEY_LEFT_BRACKET
    Backslash     = LibGLFW::KEY_BACKSLASH
    RightBracket  = LibGLFW::KEY_RIGHT_BRACKET
    GraveAccent   = LibGLFW::KEY_GRAVE_ACCENT
    World1        = LibGLFW::KEY_WORLD_1
    World2        = LibGLFW::KEY_WORLD_2
    Escape        = LibGLFW::KEY_ESCAPE
    Enter         = LibGLFW::KEY_ENTER
    Tab           = LibGLFW::KEY_TAB
    Backspace     = LibGLFW::KEY_BACKSPACE
    Insert        = LibGLFW::KEY_INSERT
    Delete        = LibGLFW::KEY_DELETE
    Right         = LibGLFW::KEY_RIGHT
    Left          = LibGLFW::KEY_LEFT
    Down          = LibGLFW::KEY_DOWN
    Up            = LibGLFW::KEY_UP
    PageUp        = LibGLFW::KEY_PAGE_UP
    PageDown      = LibGLFW::KEY_PAGE_DOWN
    Home          = LibGLFW::KEY_HOME
    End           = LibGLFW::KEY_END
    CapsLock      = LibGLFW::KEY_CAPS_LOCK
    ScrollLock    = LibGLFW::KEY_SCROLL_LOCK
    NumLock       = LibGLFW::KEY_NUM_LOCK
    PrintScreen   = LibGLFW::KEY_PRINT_SCREEN
    Pause         = LibGLFW::KEY_PAUSE
    F1            = LibGLFW::KEY_F1
    F2            = LibGLFW::KEY_F2
    F3            = LibGLFW::KEY_F3
    F4            = LibGLFW::KEY_F4
    F5            = LibGLFW::KEY_F5
    F6            = LibGLFW::KEY_F6
    F7            = LibGLFW::KEY_F7
    F8            = LibGLFW::KEY_F8
    F9            = LibGLFW::KEY_F9
    F10           = LibGLFW::KEY_F10
    F11           = LibGLFW::KEY_F11
    F12           = LibGLFW::KEY_F12
    F13           = LibGLFW::KEY_F13
    F14           = LibGLFW::KEY_F14
    F15           = LibGLFW::KEY_F15
    F16           = LibGLFW::KEY_F16
    F17           = LibGLFW::KEY_F17
    F18           = LibGLFW::KEY_F18
    F19           = LibGLFW::KEY_F19
    F20           = LibGLFW::KEY_F20
    F21           = LibGLFW::KEY_F21
    F22           = LibGLFW::KEY_F22
    F23           = LibGLFW::KEY_F23
    F24           = LibGLFW::KEY_F24
    F25           = LibGLFW::KEY_F25
    KP0           = LibGLFW::KEY_KP_0
    KP1           = LibGLFW::KEY_KP_1
    KP2           = LibGLFW::KEY_KP_2
    KP3           = LibGLFW::KEY_KP_3
    KP4           = LibGLFW::KEY_KP_4
    KP5           = LibGLFW::KEY_KP_5
    KP6           = LibGLFW::KEY_KP_6
    KP7           = LibGLFW::KEY_KP_7
    KP8           = LibGLFW::KEY_KP_8
    KP9           = LibGLFW::KEY_KP_9
    KPDecimal     = LibGLFW::KEY_KP_DECIMAL
    KPDivide      = LibGLFW::KEY_KP_DIVIDE
    KPMultiply    = LibGLFW::KEY_KP_MULTIPLY
    KPSubtract    = LibGLFW::KEY_KP_SUBTRACT
    KPAdd         = LibGLFW::KEY_KP_ADD
    KPEnter       = LibGLFW::KEY_KP_ENTER
    KPEqual       = LibGLFW::KEY_KP_EQUAL
    LeftShift     = LibGLFW::KEY_LEFT_SHIFT
    LeftControl   = LibGLFW::KEY_LEFT_CONTROL
    LeftAlt       = LibGLFW::KEY_LEFT_ALT
    LeftSuper     = LibGLFW::KEY_LEFT_SUPER
    RightShift    = LibGLFW::KEY_RIGHT_SHIFT
    RightControl  = LibGLFW::KEY_RIGHT_CONTROL
    RightAlt      = LibGLFW::KEY_RIGHT_ALT
    RightSuper    = LibGLFW::KEY_RIGHT_SUPER
    Menu          = LibGLFW::KEY_MENU
    Last          = LibGLFW::KEY_LAST
    ModShift      = LibGLFW::MOD_SHIFT
    ModAlt        = LibGLFW::MOD_ALT
    ModControl    = LibGLFW::MOD_CONTROL
    ModSuper      = LibGLFW::MOD_SUPER

    @@printable_keys = [
      Apostrophe, Comma, Minus, Period, Slash, Semicolon, Equal,
      LeftBracket, RightBracket, Backslash, World1, World2, 
      Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine,
      A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T,
      U, V, W, X, Y, Z, KP0, KP1, KP2, KP3, KP4, KP5, KP6, KP7,
      KP8, KP9, KPDecimal, KPDivide, KPMultiply, KPSubtract, KPAdd,
      KPEqual
    ]

    @@scancodes = Hash(Key, Int32).new

    def self.from(code : Int32, scancode : Int32) : Key
      Key.new(code).tap { |k| @@scancodes[k] = scancode }
    end

    def name : String
      candidate = LibGLFW.get_key_name(self.value, @@scancodes[self.value]?)
      if candidate.null?
        Error::KeyNotPrintable.raise
      else
        String.new(candidate)
      end
    end

    def printable? : Bool
      @@printable_keys.includes? self
    end
  end
end
