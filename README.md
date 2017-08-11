# CrystGLFW

An object-oriented API for GLFW in Crystal.

[GLFW](https://glfw.org) is a razor-thin, cross-platform library for spinning up OpenGL contexts via windows as well as
receiving user input and platform events. CrystGLFW provides an object-oriented API for the full GLFW specification, including
window creation, working with multiple monitors, keyboard and joystick/controller input, idiomatic callbacks, and more.

The flexibility and portability of GLFW meets the speed and ease-of-use of Crystal. What a time to be alive!

CrystGLFW uses [LibGLFW](https://github.com/calebuharrison/LibGLFW) behind the scenes.

[Read the guides!](https://calebuharrison.gitbooks.io/crystglfw-guide/content/)

## Installation

First, you'll want to make sure you've got GLFW3:

```sh
brew install glfw3
```

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crystglfw:
    github: calebuharrison/CrystGLFW
    branch: master
```

Install your dependencies:

```sh
shards install
```

## Quick Start

```crystal
require "crystglfw"
include CrystGLFW

# Initialize GLFW
CrystGLFW.run do
  # Create a new window.
  window = Window.new(title: "My First Window")

  # Configure the window to print its dimensions each time it is resized.
  window.on_resize do |event|
    puts "Window resized to #{event.width}x#{event.height}"
  end

  # Make this window's OpenGL context the current drawing context.
  window.make_context_current

  # Listen for callbacks and draw the window until it has been marked for closing.
  until window.should_close?
    CrystGLFW.wait_events
    window.swap_buffers
  end

  # Destroy the window.
  window.destroy

# Shut down and clean up GLFW.
end
```

CrystGLFW has much more to offer - check out the [guides](https://calebuharrison.gitbooks.io/crystglfw-guide/content/)!

## Contributing

1. Fork it ( https://github.com/calebuharrison/CrystGLFW/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [calebuharrison](https://github.com/calebuharrison) Caleb Uriah Harrison - creator, maintainer
