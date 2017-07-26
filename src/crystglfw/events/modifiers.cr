module CrystGLFW
  module Event
    # The Modifiers module encapsulates the instance variables and interfaces for Events that support modifier keys.
    module Modifiers
      @mod_shift : Bool = false
      @mod_control : Bool = false
      @mod_alt : Bool = false
      @mod_super : Bool = false

      private def set_modifiers(modifiers : Int32)
        @mod_shift = modifiers.bit(0) == 1
        @mod_control = modifiers.bit(1) == 1
        @mod_alt = modifiers.bit(2) == 1
        @mod_super = modifiers.bit(3) == 1
      end

      # Returns true if the shift key was held down as a modifier. False otherwise.
      #
      # ```
      # window.on_key do |key_event|
      #   puts "The shift key was held down as a modifier." if key_event.shift?
      # end
      # ```
      def shift?
        @mod_shift
      end

      # Returns true if the control key was held down as a modifier. False otherwise.
      #
      # ```
      # window.on_key do |key_event|
      #   puts "The control key was held down as a modifier." if key_event.control?
      # end
      # ```
      def control?
        @mod_control
      end

      # Returns true if the alt key was held down as a modifier. False otherwise.
      #
      # ```
      # window.on_key do |key_event|
      #   puts "The alt key was held down as a modifier." if key_event.alt?
      # end
      # ```
      def alt?
        @mod_alt
      end

      # Returns true if the super key was held down as a modifier. False otherwise.
      #
      # ```
      # window.on_key do |key_event|
      #   puts "The super key was held down as a modifier." if key_event.super?
      # end
      # ```
      def super?
        @mod_super
      end
    end
  end
end
